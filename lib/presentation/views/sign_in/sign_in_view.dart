import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/sign_in/sign_in_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_chrome.dart';
import '../../widgets/primary_button.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              context.dw(AppSpacing.t30),
              context.dw(AppSpacing.t40),
              context.dw(AppSpacing.t30),
              context.dw(AppSpacing.t24),
            ),
            child: Column(
              children: [
                AuthHeader(
                  eyebrow: 'sign_in'.tr,
                  title: 'welcome_back'.tr,
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                AppTextField(
                  label: 'email'.tr,
                  hint: 'email_hint'.tr,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: context.dw(AppSpacing.t20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Obx(
                      () => AppTextField(
                        label: 'password'.tr,
                        hint: '************',
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        showObscureToggle: true,
                        onToggleObscure: controller.toggleObscure,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    SizedBox(height: context.dw(AppSpacing.t05)),
                    GestureDetector(
                      onTap: controller.forgotPassword,
                      child: Text(
                        'forgot_password'.tr,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w600,
                          fontSize: context.dw(16),
                          height: 1.2,
                          color: AppColors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                PrimaryButton(
                  label: 'continue'.tr,
                  onPressed: controller.continuePressed,
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                const OrDivider(),
                SizedBox(height: context.dw(AppSpacing.t30)),
                SocialAuthRow(
                  onGoogle: controller.google,
                  onApple: controller.apple,
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                AuthFooterLink(
                  leading: 'no_account'.tr,
                  action: 'create_your_account_hint'.tr,
                  onTap: controller.goSignUp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
