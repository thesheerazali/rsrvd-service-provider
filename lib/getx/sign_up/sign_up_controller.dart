import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../core/services/app_flash.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

class SignUpController extends GetxController {
  SignUpController({UserRepository? repository})
      : _users = repository ?? Get.find<UserRepository>();

  final UserRepository _users;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;
  final isSubmitting = false.obs;

  void togglePassword() => obscurePassword.toggle();
  void toggleConfirm() => obscureConfirm.toggle();

  Future<void> continuePressed() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmController.text.isEmpty) {
      AppFlash.error('auth_fill_required'.tr);
      return;
    }
    if (passwordController.text != confirmController.text) {
      AppFlash.error('password_mismatch'.tr);
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      await _users.signUp(
        displayName: nameController.text,
        email: emailController.text,
      );
      Get.offAllNamed(AppRoutes.partnerApplication);
    } finally {
      isSubmitting.value = false;
    }
  }

  void goSignIn() => Get.offNamed(AppRoutes.signIn);
  void google() => AppFlash.info('coming_soon'.tr);
  void apple() => AppFlash.info('coming_soon'.tr);

  @override
  void onClose() {
    final name = nameController;
    final email = emailController;
    final password = passwordController;
    final confirm = confirmController;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      name.dispose();
      email.dispose();
      password.dispose();
      confirm.dispose();
    });
    super.onClose();
  }
}
