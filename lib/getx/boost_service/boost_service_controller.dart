import 'package:get/get.dart';

import '../../core/models/partner_service.dart';
import '../../core/models/service_boost_plan.dart';
import '../../core/services/app_flash.dart';
import '../../routes/app_routes.dart';
import '../main_shell/main_shell_controller.dart';
import '../services/services_controller.dart';

class BoostServiceController extends GetxController {
  final plans = ServiceBoostPlan.catalog.obs;
  final selectedPlanId = ''.obs;
  final isSubmitting = false.obs;
  final service = Rxn<PartnerService>();

  String get serviceId {
    final args = Get.arguments;
    if (args is String) return args;
    if (args is Map && args['service_id'] is String) {
      return args['service_id'] as String;
    }
    return '';
  }

  String get serviceTitle => service.value?.title ?? '';

  ServiceBoostPlan? get selectedPlan {
    final id = selectedPlanId.value;
    if (id.isEmpty) return null;
    for (final p in plans) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _hydrate();
    if (plans.isNotEmpty) {
      selectedPlanId.value = plans.first.id;
    }
  }

  void _hydrate() {
    if (!Get.isRegistered<ServicesController>()) return;
    for (final s in Get.find<ServicesController>().services) {
      if (s.id == serviceId) {
        service.value = s;
        return;
      }
    }
  }

  void selectPlan(String id) => selectedPlanId.value = id;

  Future<void> continueWithSelected() async {
    final plan = selectedPlan;
    final current = service.value;
    if (plan == null || current == null) {
      AppFlash.info('Select a boost package');
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      if (Get.isRegistered<ServicesController>()) {
        Get.find<ServicesController>().applyBoost(current.id);
      }
      AppFlash.success('Boost applied');
      Get.until(
        (route) =>
            route.settings.name == AppRoutes.home || route.isFirst,
      );
      if (Get.isRegistered<MainShellController>()) {
        Get.find<MainShellController>().selectTab(MainTab.services.index);
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  void goBack() => Get.back();
}
