import 'package:get/get.dart';

import '../../core/models/app_user.dart';
import '../../core/models/membership_plan.dart';
import '../../core/models/partner_application_draft.dart';
import '../../core/models/partner_application_status.dart';
import '../../core/models/user_membership.dart';
import '../../core/services/app_log.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';

/// User-domain access. Controllers never touch [StorageService] for this.
///
/// Auth = Firebase UID ([AppUser.uid] / [StorageService.authToken]).
/// [AppUser.providerId] (`RSP-XXXX`) is only a viewing field on the user doc,
/// created once at signup — same as writing `provider_id` in Firestore later.
///
/// Application gate: [applicationStatus] decides splash / post-login route
/// (see docs/application-status.md).
class UserRepository extends GetxService {
  final StorageService _storage = Get.find<StorageService>();

  static const String _tag = 'USER_REPO';

  bool get isSignedIn => _storage.isLoggedIn;

  bool get onboardingComplete => _storage.onboardingComplete;

  /// Local stand-in for `users/{uid}` until Firebase is wired.
  AppUser? get currentUser => AppUser.tryDecode(_storage.userProfile);

  PartnerApplicationDraft? get partnerApplication =>
      PartnerApplicationDraft.tryDecode(_storage.partnerApplication);

  PartnerApplicationStatus get applicationStatus {
    final stored = PartnerApplicationStatusX.fromStorage(
      _storage.applicationStatus,
    );
    // Legacy: onboarding done before status field existed → treat as active.
    if (stored == PartnerApplicationStatus.none &&
        _storage.onboardingComplete &&
        _storage.applicationStatus == null) {
      return PartnerApplicationStatus.active;
    }
    return stored;
  }

  /// Post-splash / post-login destination from session + application status.
  String get continueRoute {
    if (!isSignedIn) return AppRoutes.welcome;

    switch (applicationStatus) {
      case PartnerApplicationStatus.none:
        return AppRoutes.partnerApplication;
      case PartnerApplicationStatus.submitted:
      case PartnerApplicationStatus.approved:
      case PartnerApplicationStatus.rejected:
        return AppRoutes.applicationStatus;
      case PartnerApplicationStatus.active:
        return AppRoutes.home;
    }
  }

  Future<void> hydrateSession() async {
    AppLog.i(
      'hydrateSession signedIn=$isSignedIn uid=${currentUser?.uid} '
      'providerId=${currentUser?.providerId} '
      'status=${applicationStatus.name} '
      'onboarding=$onboardingComplete',
      tag: _tag,
    );
  }

  /// Sign up: Firebase will create [uid]; we also write `provider_id` on the user doc.
  /// Onboarding stays incomplete until [completePartnerApplication].
  Future<AppUser> signUp({
    required String displayName,
    required String email,
  }) async {
    final uid = 'fb_${DateTime.now().millisecondsSinceEpoch}';
    final providerId = _nextProviderId();
    final user = AppUser(
      uid: uid,
      providerId: providerId,
      displayName: displayName.trim(),
      email: email.trim(),
    );
    _writeUserDoc(user);
    _storage.authToken = uid;
    _storage.onboardingComplete = false;
    _setStatus(PartnerApplicationStatus.none);
    AppLog.i(
      'signUp uid=$uid providerId=$providerId email=${user.email}',
      tag: _tag,
    );
    return user;
  }

  /// Sign in: session is Firebase UID. Does not mint a new `RSP-XXXX`.
  ///
  /// Route after login via [continueRoute] (status from backend / local store).
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    assert(password.isNotEmpty);
    final trimmed = email.trim();
    final existing = currentUser;

    if (existing != null &&
        existing.email.toLowerCase() == trimmed.toLowerCase()) {
      _storage.authToken = existing.uid;
      AppLog.i(
        'signIn uid=${existing.uid} status=${applicationStatus.name}',
        tag: _tag,
      );
      return existing;
    }

    if (existing != null) {
      final updated = existing.copyWith(email: trimmed);
      _writeUserDoc(updated);
      _storage.authToken = updated.uid;
      AppLog.i(
        'signIn uid=${updated.uid} status=${applicationStatus.name}',
        tag: _tag,
      );
      return updated;
    }

    // Demo seed when no signup doc exists yet (skip application → home).
    final demo = AppUser(
      uid: 'fb_demo_provider_0041',
      providerId: 'RSP-0041',
      displayName: 'Marchetti Atelier',
      email: trimmed.isEmpty ? 'studio@marchetti.io' : trimmed,
      occupation: 'Interior Design · Miami',
      membership: UserMembership.activeFromPlan(
        const MembershipPlan(
          id: 'plan_annual',
          code: 'annual',
          name: 'Yearly Plan',
          interval: MembershipBillingInterval.yearly,
          priceCents: 550000,
          recommended: true,
          ctaShortName: 'Annual',
        ),
        now: DateTime(2026, 8, 8),
      ),
    );
    _writeUserDoc(demo);
    _storage.authToken = demo.uid;
    _storage.onboardingComplete = true;
    _setStatus(PartnerApplicationStatus.active);
    AppLog.i(
      'signIn seeded uid=${demo.uid} providerId=${demo.providerId}',
      tag: _tag,
    );
    return demo;
  }

  /// Persist application draft and lock user on the submitted status screen.
  Future<void> completePartnerApplication(PartnerApplicationDraft draft) async {
    _storage.partnerApplication = draft.encode();
    _storage.onboardingComplete = true;
    _setStatus(PartnerApplicationStatus.submitted);

    final existing = currentUser;
    if (existing != null) {
      final name = draft.businessName.trim().isNotEmpty
          ? draft.businessName.trim()
          : existing.displayName;
      final specialty = draft.expertise.isNotEmpty
          ? draft.expertise.first
          : existing.occupation;
      final location = draft.city.trim().isNotEmpty
          ? draft.city.trim()
          : '';
      final occupation = [
        if (specialty.isNotEmpty) specialty,
        if (location.isNotEmpty) location,
      ].join(' · ');
      _writeUserDoc(
        existing.copyWith(
          displayName: name,
          occupation: occupation,
        ),
      );
    }
    AppLog.i('partner application submitted → status screen', tag: _tag);
  }

  /// Local / debug (and later API) status updates.
  Future<void> setApplicationStatus(PartnerApplicationStatus status) async {
    _setStatus(status);
    if (status == PartnerApplicationStatus.none) {
      _storage.onboardingComplete = false;
    } else if (status != PartnerApplicationStatus.none) {
      _storage.onboardingComplete = true;
    }
    AppLog.i('applicationStatus → ${status.name}', tag: _tag);
  }

  /// Rejected → reopen the multi-step form for a new submission.
  Future<void> beginResubmit() async {
    await setApplicationStatus(PartnerApplicationStatus.none);
  }

  /// Persist purchased [plan] on the user doc and unlock Home (`active`).
  ///
  /// [gatewaySubscriptionId] comes from [MembershipRepository.startCheckout]
  /// (or the real gateway webhook / confirm response later).
  Future<void> activateMembership(
    MembershipPlan plan, {
    String? gatewaySubscriptionId,
  }) async {
    final existing = currentUser;
    if (existing == null) {
      AppLog.w('activateMembership: no user doc', tag: _tag);
      return;
    }
    final membership = UserMembership.activeFromPlan(
      plan,
      gatewaySubscriptionId: gatewaySubscriptionId,
    );
    _writeUserDoc(existing.copyWith(membership: membership));
    await setApplicationStatus(PartnerApplicationStatus.active);
    AppLog.i(
      'membership active plan=${plan.code} sub=$gatewaySubscriptionId',
      tag: _tag,
    );
  }

  Future<void> signOut() async {
    _storage.authToken = null;
    AppLog.i('Signed out (user doc + status kept)', tag: _tag);
  }

  void _setStatus(PartnerApplicationStatus status) {
    _storage.applicationStatus = status.storageValue;
  }

  void _writeUserDoc(AppUser user) {
    _storage.userProfile = user.encode();
  }

  /// Viewing id only — stored on the user document at signup.
  String _nextProviderId() {
    final seq = _storage.providerSeq;
    _storage.providerSeq = seq + 1;
    return 'RSP-${seq.toString().padLeft(4, '0')}';
  }
}
