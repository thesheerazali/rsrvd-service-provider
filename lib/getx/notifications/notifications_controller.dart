import 'package:get/get.dart';

import '../../core/models/notification_prefs.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/settings_repository.dart';

class NotificationsController extends GetxController {
  NotificationsController({SettingsRepository? repository})
      : _repository = repository ?? Get.find<SettingsRepository>();

  final SettingsRepository _repository;
  static const String _tag = 'NOTIFICATIONS';

  final prefs = const NotificationPrefs().obs;

  @override
  void onInit() {
    super.onInit();
    prefs.value = _repository.fetchNotificationPrefs();
  }

  void goBack() => Get.back();

  Future<void> setServiceUpdates(bool v) =>
      _update(prefs.value.copyWith(serviceUpdates: v));

  Future<void> setNewOpportunities(bool v) =>
      _update(prefs.value.copyWith(newOpportunities: v));

  Future<void> setMemberRequests(bool v) =>
      _update(prefs.value.copyWith(memberRequests: v));

  Future<void> setMessageUpdates(bool v) =>
      _update(prefs.value.copyWith(messageUpdates: v));

  Future<void> setProjectUpdates(bool v) =>
      _update(prefs.value.copyWith(projectUpdates: v));

  Future<void> setReviewRatings(bool v) =>
      _update(prefs.value.copyWith(reviewRatings: v));

  Future<void> setMembershipUpdates(bool v) =>
      _update(prefs.value.copyWith(membershipUpdates: v));

  Future<void> setAccountSecurity(bool v) =>
      _update(prefs.value.copyWith(accountSecurity: v));

  Future<void> _update(NotificationPrefs next) async {
    prefs.value = next;
    try {
      await _repository.saveNotificationPrefs(next);
    } catch (e, st) {
      AppLog.e('save prefs failed: $e', tag: _tag, error: e, stackTrace: st);
    }
  }
}
