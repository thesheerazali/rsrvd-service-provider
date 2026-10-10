import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../core/services/app_flash.dart';
import '../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void sendCode() {
    if (emailController.text.trim().isEmpty) {
      AppFlash.error('auth_fill_required'.tr);
      return;
    }
    Get.toNamed(AppRoutes.idVerification);
  }

  @override
  void onClose() {
    final email = emailController;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      email.dispose();
    });
    super.onClose();
  }
}
