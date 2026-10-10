import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../core/services/app_flash.dart';
import '../../routes/app_routes.dart';

class IdVerificationController extends GetxController {
  final digits = List.generate(4, (_) => TextEditingController());
  final focuses = List.generate(4, (_) => FocusNode());
  final secondsLeft = 30.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    secondsLeft.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value <= 0) {
        t.cancel();
        return;
      }
      secondsLeft.value--;
    });
  }

  void onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      focuses[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focuses[index - 1].requestFocus();
    }
  }

  String get code => digits.map((c) => c.text).join();

  void verify() {
    if (code.length < 4) {
      AppFlash.error('otp_incomplete'.tr);
      return;
    }
    Get.toNamed(AppRoutes.updatePassword);
  }

  void resend() {
    if (secondsLeft.value > 0) return;
    for (final c in digits) {
      c.clear();
    }
    focuses.first.requestFocus();
    _startTimer();
    AppFlash.success('otp_resent'.tr);
  }

  @override
  void onClose() {
    _timer?.cancel();
    final digitControllers = List<TextEditingController>.from(digits);
    final focusNodes = List<FocusNode>.from(focuses);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      for (final c in digitControllers) {
        c.dispose();
      }
      for (final f in focusNodes) {
        f.dispose();
      }
    });
    super.onClose();
  }
}
