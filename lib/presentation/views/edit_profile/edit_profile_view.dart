import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/edit_profile/edit_profile_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_removable_chip.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

/// Settings → Edit Profile — Figma Partner edit; fields mirror SP onboarding.
class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(
          child: Column(
            children: [
              const _Header(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t40),
                  ),
                  children: [
                    const _AvatarEditor(),
                    SizedBox(height: context.dw(AppSpacing.t30)),
                    AppTextField(
                      label: 'edit_profile_full_name'.tr,
                      hint: 'Alexa Miguel',
                      controller: controller.nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      inputFormatters: _FieldInput.textOnly,
                    ),
                    SizedBox(height: context.dw(AppSpacing.t20)),
                    AppTextField(
                      label: 'edit_profile_email'.tr,
                      hint: 'alexa@gmail.com',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: context.dw(AppSpacing.t20)),
                    AppTextField(
                      label: 'edit_profile_phone'.tr,
                      hint: '+1 234 560 7890',
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: _FieldInput.phone,
                    ),
                    SizedBox(height: context.dw(AppSpacing.t20)),
                    AppTextField(
                      label: 'edit_profile_primary_category'.tr,
                      hint: 'Architect',
                      controller: controller.primaryCategoryController,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: context.dw(AppSpacing.t20)),
                    AppTextField(
                      label: 'edit_profile_experience'.tr,
                      hint: '08 years',
                      controller: controller.experienceController,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: context.dw(AppSpacing.t20)),
                    AppTextField(
                      label: 'pa_expertise'.tr,
                      hint: 'pa_expertise_hint'.tr,
                      controller: controller.expertiseInputController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: controller.addExpertise,
                    ),
                    SizedBox(height: context.dw(AppSpacing.t08)),
                    Obx(
                      () => AppRemovableChipWrap(
                        values: controller.expertise.toList(),
                        onRemove: controller.removeExpertise,
                      ),
                    ),
                    SizedBox(height: context.dw(AppSpacing.t20)),
                    AppTextField(
                      label: 'pa_service_areas'.tr,
                      hint: 'pa_service_areas_hint'.tr,
                      controller: controller.serviceAreaInputController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: controller.addServiceArea,
                    ),
                    SizedBox(height: context.dw(AppSpacing.t08)),
                    Obx(
                      () => AppRemovableChipWrap(
                        values: controller.serviceAreas.toList(),
                        onRemove: controller.removeServiceArea,
                      ),
                    ),
                    SizedBox(height: context.dw(AppSpacing.t30)),
                    Obx(
                      () => PrimaryButton(
                        label: 'edit_profile_save'.tr,
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.saveChanges,
                        enabled: !controller.isSaving.value,
                      ),
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

abstract class _FieldInput {
  static final textOnly = [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s\-']")),
  ];
  static final phone = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-()]')),
  ];
}

class _Header extends GetView<EditProfileController> {
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
            'edit_profile_title'.tr,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w600,
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

class _AvatarEditor extends GetView<EditProfileController> {
  const _AvatarEditor();

  @override
  Widget build(BuildContext context) {
    final size = context.dw(100);
    final badge = context.dw(36);
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Obx(
                () => Text(
                  controller.initials.value,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(32),
                    height: 1.0,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: controller.changeAvatar,
                child: Container(
                  width: badge,
                  height: badge,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surfaceCard, width: 1),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.iconEditProfile,
                    width: context.dw(14),
                    height: context.dw(14),
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
