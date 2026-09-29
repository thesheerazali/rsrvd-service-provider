import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/models/partner_application_status.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

/// Post-submit gate: Submitted / Approved / Rejected until membership or resubmit.
class ApplicationStatusController extends GetxController {
  ApplicationStatusController({UserRepository? repository})
      : _users = repository ?? Get.find<UserRepository>();

  final UserRepository _users;
  static const String _tag = 'APP_STATUS';

  final status = PartnerApplicationStatus.submitted.obs;

  bool get showDebugToggles => kDebugMode;

  @override
  void onInit() {
    super.onInit();
    _syncFromRepo();
  }

  void _syncFromRepo() {
    final current = _users.applicationStatus;
    status.value = current.locksToStatusScreen
        ? current
        : PartnerApplicationStatus.submitted;
  }

  Future<void> debugSetStatus(PartnerApplicationStatus next) async {
    if (!showDebugToggles) return;
    if (!next.locksToStatusScreen && next != PartnerApplicationStatus.active) {
      return;
    }
    await _users.setApplicationStatus(next);
    if (next == PartnerApplicationStatus.active) {
      Get.offAllNamed(AppRoutes.home);
      return;
    }
    status.value = next;
    AppLog.i('debug status → ${next.name}', tag: _tag);
  }

  Future<void> logout() async {
    await _users.signOut();
    Get.offAllNamed(AppRoutes.welcome);
  }

  Future<void> continueToMembership() async {
    Get.toNamed(AppRoutes.membership);
  }

  Future<void> resubmitApplication() async {
    await _users.beginResubmit();
    Get.offAllNamed(AppRoutes.partnerApplication);
  }
}
