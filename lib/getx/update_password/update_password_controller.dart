import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../core/services/app_flash.dart';
import '../../routes/app_routes.dart';
import '../sign_in/sign_in_controller.dart';

class UpdatePasswordController extends GetxController {
  final currentController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final obscureCurrent = true.obs;
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;

  /// Settings → Change Password uses profile chrome; auth flow keeps CTA redirect.
  bool get fromSettings {
    final args = Get.arguments;
    if (args is Map && args['mode'] == 'settings') return true;
    return Get.previousRoute == AppRoutes.settings;
  }

  void toggleCurrent() => obscureCurrent.toggle();
  void togglePassword() => obscurePassword.toggle();
  void toggleConfirm() => obscureConfirm.toggle();

  void goBack() => Get.back();

  void updatePassword() {
    if (fromSettings && currentController.text.isEmpty) {
      AppFlash.error('auth_fill_required'.tr);
      return;
    }
    if (passwordController.text.isEmpty || confirmController.text.isEmpty) {
      AppFlash.error('auth_fill_required'.tr);
      return;
    }
    if (passwordController.text != confirmController.text) {
      AppFlash.error('password_mismatch'.tr);
      return;
    }
    if (fromSettings) {
      AppFlash.successAndBack('password_updated'.tr);
      return;
    }
    AppFlash.success('password_updated'.tr);
    if (Get.isRegistered<SignInController>()) {
      Get.find<SignInController>().clearFields();
    }
    Get.offAllNamed(AppRoutes.signIn);
  }

  @override
  void onClose() {
    final current = currentController;
    final password = passwordController;
    final confirm = confirmController;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      current.dispose();
      password.dispose();
      confirm.dispose();
    });
    super.onClose();
  }
}
