import 'package:get/get.dart';

import '../../core/models/membership_plan.dart';
import '../../core/services/app_flash.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/membership_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

/// Choose A Plan — Figma `1196:132`.
class MembershipController extends GetxController {
  MembershipController({
    MembershipRepository? membershipRepository,
    UserRepository? userRepository,
  })  : _membership = membershipRepository ?? Get.find<MembershipRepository>(),
        _users = userRepository ?? Get.find<UserRepository>();

  final MembershipRepository _membership;
  final UserRepository _users;
  static const String _tag = 'MEMBERSHIP';

  final plans = <MembershipPlan>[].obs;
  final selectedPlanId = ''.obs;
  final isSubmitting = false.obs;

  MembershipPlan? get selectedPlan {
    final id = selectedPlanId.value;
    for (final plan in plans) {
      if (plan.id == id) return plan;
    }
    return null;
  }

  String get continueLabel =>
      selectedPlan?.continueCtaLabel ?? 'Continue with Annual';

  @override
  void onInit() {
    super.onInit();
    _loadPlans();
  }

  void _loadPlans() {
    final catalog = _membership.listPlans();
    plans.assignAll(catalog);
    MembershipPlan? recommended;
    for (final plan in catalog) {
      if (plan.recommended) {
        recommended = plan;
        break;
      }
    }
    selectedPlanId.value = (recommended ?? catalog.firstOrNull)?.id ?? '';
  }

  void selectPlan(String id) => selectedPlanId.value = id;

  Future<void> continueWithSelectedPlan() async {
    final plan = selectedPlan;
    if (plan == null) {
      AppFlash.error('membership_select_plan'.tr);
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      final subId = await _membership.startCheckout(plan);
      await _users.activateMembership(
        plan,
        gatewaySubscriptionId: subId,
      );
      AppLog.i('activated ${plan.code}', tag: _tag);
      Get.offAllNamed(AppRoutes.home);
    } finally {
      isSubmitting.value = false;
    }
  }

  void goBack() {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    } else {
      Get.offAllNamed(AppRoutes.applicationStatus);
    }
  }
}
