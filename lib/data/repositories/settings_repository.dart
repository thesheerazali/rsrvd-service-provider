import 'package:get/get.dart';

import '../../core/models/app_user.dart';
import '../../core/models/notification_prefs.dart';
import '../../core/services/app_log.dart';
import '../../core/services/storage_service.dart';
import 'user_repository.dart';

/// Thin settings façade — edit profile + notification prefs.
class SettingsRepository extends GetxService {
  SettingsRepository({
    UserRepository? users,
    StorageService? storage,
  })  : _users = users ?? Get.find<UserRepository>(),
        _storage = storage ?? Get.find<StorageService>();

  final UserRepository _users;
  final StorageService _storage;
  static const String _tag = 'SETTINGS_REPO';

  AppUser? get currentUser => _users.currentUser;

  Future<AppUser> updateProfile({
    required String displayName,
    required String email,
    required String occupation,
    String? phone,
    String? experienceYears,
    List<String>? expertise,
    List<String>? serviceAreas,
  }) {
    return _users.updateProfile(
      displayName: displayName,
      email: email,
      occupation: occupation,
      phone: phone,
      experienceYears: experienceYears,
      expertise: expertise,
      serviceAreas: serviceAreas,
    );
  }

  NotificationPrefs fetchNotificationPrefs() {
    final raw = _storage.notificationPrefs;
    if (raw == null) return const NotificationPrefs();
    return NotificationPrefs.fromJson(raw);
  }

  Future<void> saveNotificationPrefs(NotificationPrefs prefs) async {
    _storage.notificationPrefs = prefs.toJson();
    AppLog.i('saveNotificationPrefs', tag: _tag);
  }
}
