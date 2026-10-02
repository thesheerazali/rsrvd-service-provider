import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/home/home_controller.dart';
import '../../widgets/empty_services_block.dart';
import '../../widgets/gold_divider.dart';

/// Partners home — Figma `1196:1742`.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HomeHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              context.dw(AppSpacing.t30),
              context.dw(AppSpacing.t20),
              context.dw(AppSpacing.t30),
              context.dw(AppSpacing.t30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _MembershipCard(),
                SizedBox(height: context.dw(AppSpacing.t30)),
                const _StatsGrid(),
                SizedBox(height: context.dw(AppSpacing.t30)),
                const GoldDivider(),
                SizedBox(height: context.dw(AppSpacing.t30)),
                EmptyServicesBlock(
                  onAddPressed: controller.onAddFirstService,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeHeader extends GetView<HomeController> {
  const _HomeHeader();

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.businessName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w600,
                    fontSize: context.dw(24),
                    height: 1.2,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  controller.businessSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(18),
                    height: 1.2,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.dw(AppSpacing.t12)),
          GestureDetector(
            onTap: controller.onNotifications,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              AppIcons.iconNotification,
              width: context.dw(37),
              height: context.dw(37),
            ),
          ),
        ],
      ),
    );
  }
}

class _MembershipCard extends GetView<HomeController> {
  const _MembershipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusLg)),
        border: Border.all(color: AppColors.surfaceCard),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.membershipLabel,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w600,
                    fontSize: context.dw(16),
                    height: 1.0,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t10)),
                Text(
                  controller.membershipStatus,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    fontSize: context.dw(20),
                    height: 1.0,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t10)),
                Text(
                  controller.membershipRenews,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(16),
                    height: 1.0,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.dw(AppSpacing.t10)),
          GestureDetector(
            onTap: controller.onManageMembership,
            child: Container(
              width: context.dw(96),
              height: context.dw(40),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
                border: Border.all(color: AppColors.primary),
              ),
              child: Text(
                'manage'.tr,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w600,
                  fontSize: context.dw(18),
                  height: 1.2,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends GetView<HomeController> {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: controller.newMessages.value,
                  label: 'stat_new_messages'.tr,
                  icon: AppIcons.statMessages,
                ),
              ),
              SizedBox(width: context.dw(AppSpacing.t20)),
              Expanded(
                child: _StatCard(
                  value: controller.activeProjects.value,
                  label: 'stat_active_projects'.tr,
                  icon: AppIcons.statBriefcase,
                ),
              ),
            ],
          ),
          SizedBox(height: context.dw(AppSpacing.t20)),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: controller.pendingContracts.value,
                  label: 'stat_pending_contracts'.tr,
                  icon: AppIcons.statLicense,
                ),
              ),
              SizedBox(width: context.dw(AppSpacing.t20)),
              Expanded(
                child: _StatCard(
                  value: controller.completedProjects.value,
                  label: 'stat_completed_projects'.tr,
                  icon: AppIcons.statTaskDone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final int value;
  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusLg)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.toString().padLeft(2, '0'),
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w600,
                    fontSize: context.dw(18),
                    height: 1.0,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t07)),
                Text(
                  label,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(16),
                    height: 1.0,
                    color: AppColors.text.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            icon,
            width: context.dw(21),
            height: context.dw(21),
            // colorFilter: const ColorFilter.mode(
            //   AppColors.text,
            //   BlendMode.srcIn,
            // ),
          ),
        ],
      ),
    );
  }
}
