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

  Future<void> setNewMemberMessages(bool v) =>
      _update(prefs.value.copyWith(newMemberMessages: v));

  Future<void> setContractActivity(bool v) =>
      _update(prefs.value.copyWith(contractActivity: v));

  Future<void> setPaymentsAndReleases(bool v) =>
      _update(prefs.value.copyWith(paymentsAndReleases: v));

  Future<void> setProjectStatusUpdates(bool v) =>
      _update(prefs.value.copyWith(projectStatusUpdates: v));

  Future<void> setMembershipAndRenewals(bool v) =>
      _update(prefs.value.copyWith(membershipAndRenewals: v));

  Future<void> _update(NotificationPrefs next) async {
    prefs.value = next;
    try {
      await _repository.saveNotificationPrefs(next);
    } catch (e, st) {
      AppLog.e('save prefs failed: $e', tag: _tag, error: e, stackTrace: st);
    }
  }
}
