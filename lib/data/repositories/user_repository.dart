import 'package:get/get.dart';

import '../../core/models/app_user.dart';
import '../../core/services/app_log.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';

/// User-domain access. Controllers never touch [StorageService] for this.
///
/// Auth = Firebase UID ([AppUser.uid] / [StorageService.authToken]).
/// [AppUser.providerId] (`RSP-XXXX`) is only a viewing field on the user doc,
/// created once at signup — same as writing `provider_id` in Firestore later.
class UserRepository extends GetxService {
  final StorageService _storage = Get.find<StorageService>();

  static const String _tag = 'USER_REPO';

  bool get isSignedIn => _storage.isLoggedIn;

  bool get onboardingComplete => _storage.onboardingComplete;

  /// Local stand-in for `users/{uid}` until Firebase is wired.
  AppUser? get currentUser => AppUser.tryDecode(_storage.userProfile);

  String get continueRoute {
    if (!isSignedIn) return AppRoutes.welcome;
    return AppRoutes.home;
  }

  Future<void> hydrateSession() async {
    AppLog.i(
      'hydrateSession signedIn=$isSignedIn uid=${currentUser?.uid} '
      'providerId=${currentUser?.providerId}',
      tag: _tag,
    );
  }

  /// Sign up: Firebase will create [uid]; we also write `provider_id` on the user doc.
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
    _setAuthSession(uid);
    AppLog.i(
      'signUp uid=$uid providerId=$providerId email=${user.email}',
      tag: _tag,
    );
    return user;
  }

  /// Sign in: session is Firebase UID. Does not mint a new `RSP-XXXX`.
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    assert(password.isNotEmpty);
    final trimmed = email.trim();
    final existing = currentUser;

    if (existing != null &&
        existing.email.toLowerCase() == trimmed.toLowerCase()) {
      _setAuthSession(existing.uid);
      AppLog.i('signIn uid=${existing.uid}', tag: _tag);
      return existing;
    }

    if (existing != null) {
      final updated = AppUser(
        uid: existing.uid,
        providerId: existing.providerId,
        displayName: existing.displayName,
        email: trimmed,
        occupation: existing.occupation,
      );
      _writeUserDoc(updated);
      _setAuthSession(updated.uid);
      AppLog.i('signIn uid=${updated.uid}', tag: _tag);
      return updated;
    }

    // Demo seed when no signup doc exists yet.
    final demo = AppUser(
      uid: 'fb_demo_provider_0041',
      providerId: 'RSP-0041',
      displayName: 'Jordan Hale',
      email: trimmed.isEmpty ? 'j.hale@atelier.io' : trimmed,
      occupation: 'Interior Studio',
    );
    _writeUserDoc(demo);
    _setAuthSession(demo.uid);
    AppLog.i(
      'signIn seeded uid=${demo.uid} providerId=${demo.providerId}',
      tag: _tag,
    );
    return demo;
  }

  Future<void> signOut() async {
    _storage.authToken = null;
    AppLog.i('Signed out (user doc kept)', tag: _tag);
  }

  void _writeUserDoc(AppUser user) {
    _storage.userProfile = user.encode();
  }

  void _setAuthSession(String firebaseUid) {
    _storage.authToken = firebaseUid;
    _storage.onboardingComplete = true;
  }

  /// Viewing id only — stored on the user document at signup.
  String _nextProviderId() {
    final seq = _storage.providerSeq;
    _storage.providerSeq = seq + 1;
    return 'RSP-${seq.toString().padLeft(4, '0')}';
  }
}
