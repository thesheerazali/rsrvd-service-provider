import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/models/partner_service.dart';
import '../../routes/app_routes.dart';
import '../main_shell/main_shell_controller.dart';
import '../services/services_controller.dart';

class ServiceReviewStatusController extends GetxController {
  final status = PartnerServiceReviewStatus.pending.obs;
  final service = Rxn<PartnerService>();

  bool get showDebugToggles => kDebugMode;

  String get serviceId {
    final args = Get.arguments;
    if (args is String) return args;
    if (args is Map && args['id'] is String) return args['id'] as String;
    return '';
  }

  String get rejectionReason =>
      service.value?.rejectionReason.isNotEmpty == true
          ? service.value!.rejectionReason
          : 'You don’t have prior experience in this service.';

  @override
  void onInit() {
    super.onInit();
    _hydrate();
  }

  void _hydrate() {
    if (!Get.isRegistered<ServicesController>()) return;
    PartnerService? match;
    for (final s in Get.find<ServicesController>().services) {
      if (s.id == serviceId) {
        match = s;
        break;
      }
    }
    if (match != null) {
      service.value = match;
      status.value = match.reviewStatus;
    }
  }

  void debugSetStatus(PartnerServiceReviewStatus value) {
    status.value = value;
    final current = service.value;
    if (current == null) return;
    final updated = current.copyWith(reviewStatus: value);
    service.value = updated;
    if (Get.isRegistered<ServicesController>()) {
      Get.find<ServicesController>().upsertService(updated);
    }
  }

  void continueToHome() {
    Get.until(
      (route) =>
          route.settings.name == AppRoutes.home || route.isFirst,
    );
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().selectTab(MainTab.home.index);
    }
  }

  void resubmit() {
    Get.offNamed(AppRoutes.createService);
  }

  void goBack() => Get.back();
}
