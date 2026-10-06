import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/update_password/update_password_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

/// Update Password — Settings chrome (same as Elite) or auth flow.
class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final fromSettings = controller.fromSettings;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: fromSettings ? AppGlowStyle.home : AppGlowStyle.auth,
        child: SafeArea(
          child: Column(
            children: [
              if (fromSettings) const _Header(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    context.dw(AppSpacing.t30),
                    fromSettings
                        ? context.dw(AppSpacing.t20)
                        : context.dw(AppSpacing.t40),
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t40),
                  ),
                  children: [
                    if (!fromSettings) ...[
                      Text(
                        'update_password_title'.tr.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(32),
                          height: 1.2,
                          letterSpacing: 0,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t15)),
                      Text(
                        'update_password_body'.tr,
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
                    ],
                    if (fromSettings) ...[
                      Obx(
                        () => AppTextField(
                          label: 'update_password_current'.tr,
                          hint: '************',
                          controller: controller.currentController,
                          obscureText: controller.obscureCurrent.value,
                          showObscureToggle: true,
                          onToggleObscure: controller.toggleCurrent,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t16)),
                    ],
                    Obx(
                      () => AppTextField(
                        label: fromSettings
                            ? 'update_password_new'.tr
                            : 'set_password'.tr,
                        hint: '************',
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        showObscureToggle: true,
                        onToggleObscure: controller.togglePassword,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: context.dw(AppSpacing.t16)),
                    Obx(
                      () => AppTextField(
                        label: 'confirm_password'.tr,
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
                      label: 'update_password_cta'.tr,
                      onPressed: controller.updatePassword,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends GetView<UpdatePasswordController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceCard, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t10),
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t16),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.goBack,
            child: SvgPicture.asset(
              AppIcons.iconArrowLeft,
              width: context.dw(24),
              height: context.dw(24),
            ),
          ),
          SizedBox(width: context.dw(AppSpacing.t12)),
          Text(
            'update_password_cta'.tr,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(24),
              height: 1.2,
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
