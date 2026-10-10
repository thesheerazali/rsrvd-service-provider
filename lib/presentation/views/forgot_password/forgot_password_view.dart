import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/forgot_password/forgot_password_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

/// Forgot Password — same Elite auth flow.
class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.auth,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.dw(AppSpacing.t30),
              context.dw(AppSpacing.t40),
              context.dw(AppSpacing.t30),
              context.dw(AppSpacing.t24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'forget_password_title'.tr.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    fontSize: context.dw(32),
                    height: 1.2,
                    letterSpacing: 0,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t15)),
                Text(
                  'forget_password_body'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w400,
                    fontSize: context.dw(24),
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                AppTextField(
                  label: 'email'.tr,
                  hint: 'email_hint'.tr,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                PrimaryButton(
                  label: 'send_code'.tr,
                  onPressed: controller.sendCode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
