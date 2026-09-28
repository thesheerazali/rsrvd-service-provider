import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/sign_up/sign_up_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_chrome.dart';
import '../../widgets/primary_button.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

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
                  eyebrow: 'sign_up'.tr,
                  title: 'create_your_account'.tr,
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                AppTextField(
                  label: 'full_name_required'.tr,
                  hint: 'full_name_hint'.tr,
                  controller: controller.nameController,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: context.dw(AppSpacing.t20)),
                AppTextField(
                  label: 'email_required'.tr,
                  hint: 'email_hint'.tr,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: context.dw(AppSpacing.t20)),
                Obx(
                  () => AppTextField(
                    label: 'set_password_required'.tr,
                    hint: '************',
                    controller: controller.passwordController,
                    obscureText: controller.obscurePassword.value,
                    showObscureToggle: true,
                    onToggleObscure: controller.togglePassword,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t20)),
                Obx(
                  () => AppTextField(
                    label: 'confirm_password_required'.tr,
                    hint: '************',
                    controller: controller.confirmController,
                    obscureText: controller.obscureConfirm.value,
                    showObscureToggle: true,
                    onToggleObscure: controller.toggleConfirm,
                    textInputAction: TextInputAction.done,
                  ),
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
                  leading: 'have_account'.tr,
                  action: 'sign_in'.tr,
                  onTap: controller.goSignIn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
