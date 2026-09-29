import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../core/services/app_flash.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

class SignInController extends GetxController {
  SignInController({UserRepository? repository})
      : _users = repository ?? Get.find<UserRepository>();

  final UserRepository _users;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final isSubmitting = false.obs;

  void toggleObscure() => obscurePassword.toggle();

  Future<void> continuePressed() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      AppFlash.error('auth_fill_required'.tr);
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      await _users.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      clearFields();
      Get.offAllNamed(_users.continueRoute);
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  void forgotPassword() => AppFlash.info('coming_soon'.tr);

  void goSignUp() => Get.toNamed(AppRoutes.signUp);

  void google() => AppFlash.info('coming_soon'.tr);
  void apple() => AppFlash.info('coming_soon'.tr);

  @override
  void onClose() {
    final email = emailController;
    final password = passwordController;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      email.dispose();
      password.dispose();
    });
    super.onClose();
  }
}
