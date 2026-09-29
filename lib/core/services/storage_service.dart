import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Keys used for persisted local storage. Keep them centralized to avoid typos.
abstract class StorageKeys {
  static const String authToken = 'auth_token';
  static const String onboardingComplete = 'onboarding_complete';
  static const String userProfile = 'user_profile';
  static const String languageCode = 'language_code';
  /// Next numeric suffix for local `RSP-XXXX` provider ids.
  static const String providerSeq = 'provider_seq';
  static const String partnerApplication = 'partner_application';
  /// [PartnerApplicationStatus.name] — see docs/application-status.md.
  static const String applicationStatus = 'application_status';
}

/// Thin, typed wrapper around [GetStorage] for simple key-value persistence.
/// Registered as a permanent [GetxService] so it lives for the whole app session.
///
/// Usage:
/// ```dart
/// await StorageService.init();
/// Get.put(StorageService(), permanent: true);
/// final storage = Get.find<StorageService>();
/// ```
class StorageService extends GetxService {
  final GetStorage _box = GetStorage();

  /// Must be called once before the service is used (e.g. in `main`).
  static Future<void> init() => GetStorage.init();

  // --- Auth ---
  String? get authToken => _box.read<String>(StorageKeys.authToken);
  set authToken(String? value) => _write(StorageKeys.authToken, value);
  bool get isLoggedIn => (authToken ?? '').isNotEmpty;

  // --- Onboarding ---
  bool get onboardingComplete =>
      _box.read<bool>(StorageKeys.onboardingComplete) ?? false;
  set onboardingComplete(bool value) =>
      _box.write(StorageKeys.onboardingComplete, value);

  // --- Profile ---
  /// JSON-encoded user profile (Firebase-ready shape when backend lands).
  String? get userProfile => _box.read<String>(StorageKeys.userProfile);
  set userProfile(String? value) => _write(StorageKeys.userProfile, value);

  /// Local counter for generating `RSP-XXXX` ids (starts at 41).
  int get providerSeq => _box.read<int>(StorageKeys.providerSeq) ?? 41;
  set providerSeq(int value) => _box.write(StorageKeys.providerSeq, value);

  /// JSON partner application draft / submitted payload.
  String? get partnerApplication =>
      _box.read<String>(StorageKeys.partnerApplication);
  set partnerApplication(String? value) =>
      _write(StorageKeys.partnerApplication, value);

  /// Partner review / membership gate (`none` | `submitted` | …).
  String? get applicationStatus =>
      _box.read<String>(StorageKeys.applicationStatus);
  set applicationStatus(String? value) =>
      _write(StorageKeys.applicationStatus, value);

  // --- Localization ---
  String? get languageCode => _box.read<String>(StorageKeys.languageCode);
  set languageCode(String? value) => _write(StorageKeys.languageCode, value);

  /// Clears all keys — use on sign-out / account delete.
  Future<void> clearAll() => _box.erase();

  void _write(String key, String? value) {
    if (value == null) {
      _box.remove(key);
    } else {
      _box.write(key, value);
    }
  }
}
