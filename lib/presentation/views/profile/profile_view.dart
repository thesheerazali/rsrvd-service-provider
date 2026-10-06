import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/profile/profile_controller.dart';

/// Partners Profile tab — Figma `1196:3096`.
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _ProfileHeader(),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.displayName.value.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            return ListView(
              padding: EdgeInsets.fromLTRB(
                context.dw(AppSpacing.t30),
                context.dw(AppSpacing.t20),
                context.dw(AppSpacing.t30),
                context.dw(AppSpacing.t40),
              ),
              children: [
                const _IdentityRow(),
                SizedBox(height: context.dw(AppSpacing.t30)),
                Text(
                  'profile_overview_title'.tr,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w600,
                    fontSize: context.dw(24),
                    height: 1.2,
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                const _BioCard(),
                SizedBox(height: context.dw(AppSpacing.t30)),
                const _OverviewSpecsCard(),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _ProfileHeader extends GetView<ProfileController> {
  const _ProfileHeader();

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
          Expanded(
            child: Text(
              'tab_profile'.tr,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w600,
                fontSize: context.dw(24),
                height: 1.2,
                color: AppColors.text.withValues(alpha: 0.8),
              ),
            ),
          ),
          GestureDetector(
            onTap: controller.openSettings,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              AppIcons.iconSettings,
              width: context.dw(24),
              height: context.dw(24),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityRow extends GetView<ProfileController> {
  const _IdentityRow();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final size = context.dw(56);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFF181818),
              shape: BoxShape.circle,
            ),
            child: Text(
              controller.initials.value,
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(20),
                height: 1.0,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: context.dw(AppSpacing.t10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  controller.displayName.value,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w600,
                    fontSize: context.dw(32),
                    height: 1.0,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t10)),
                Text(
                  controller.subtitle.value,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(20),
                    height: 1.0,
                    color: AppColors.text.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _BioCard extends GetView<ProfileController> {
  const _BioCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: context.dw(8),
              offset: Offset(0, context.dw(2)),
            ),
          ],
        ),
        child: Text(
          controller.bio.value,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w400,
            fontSize: context.dw(20),
            height: 22 / 20,
            color: AppColors.text,
          ),
        ),
      );
    });
  }
}

/// Figma “Settings Container” — label / value overview rows.
class _OverviewSpecsCard extends GetView<ProfileController> {
  const _OverviewSpecsCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = controller.overviewRows;
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: context.dw(8),
              offset: Offset(0, context.dw(2)),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dw(AppSpacing.t20),
                  vertical: context.dw(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        rows[i].label,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(18),
                          height: 1.2,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    SizedBox(width: context.dw(AppSpacing.t10)),
                    Expanded(
                      child: Text(
                        rows[i].value,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w600,
                          fontSize: context.dw(20),
                          height: 1.2,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (i != rows.length - 1)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.surfaceCard,
                ),
            ],
          ],
        ),
      );
    });
  }
}
