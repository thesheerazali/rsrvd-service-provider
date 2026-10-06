import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/membership/membership_manage_controller.dart';
import '../../widgets/app_back_title_header.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_figma_switch.dart';
import '../../widgets/primary_button.dart';

/// Settings / Home → Membership manage — Partner active plan UI.
class MembershipManageView extends GetView<MembershipManageController> {
  const MembershipManageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppBackTitleHeader(
                title: 'settings_membership'.tr,
                onBack: controller.goBack,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t20),
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t40),
                  ),
                  children: [
                    const _StatusCard(),
                    SizedBox(height: context.dw(AppSpacing.t30)),
                    const _DetailsList(),
                    SizedBox(height: context.dw(AppSpacing.t30)),
                    Text(
                      'membership_included'.tr,
                      style: GoogleFonts.cinzel(
                        fontWeight: FontWeight.w700,
                        fontSize: context.dw(24),
                        height: 1.0,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: context.dw(AppSpacing.t16)),
                    const _IncludedCard(),
                    SizedBox(height: context.dw(AppSpacing.t30)),
                    PrimaryButton(
                      label: 'membership_payment_history'.tr,
                      onPressed: controller.openPaymentHistory,
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

class _StatusCard extends GetView<MembershipManageController> {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
        border: Border.all(color: AppColors.surfaceCard, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.planEyebrow,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(16),
              height: 1.0,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: context.dw(AppSpacing.t10)),
          Text(
            controller.statusLabel,
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.w700,
              fontSize: context.dw(32),
              height: 1.0,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: context.dw(AppSpacing.t10)),
          Text(
            controller.renewsHeadline,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(16),
              height: 1.0,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsList extends GetView<MembershipManageController> {
  const _DetailsList();

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(20),
      height: 32 / 20,
      color: AppColors.white,
    );
    final valueStyle = labelStyle;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
        border: Border.all(color: AppColors.surfaceCard, width: 0.5),
      ),
      child: Column(
        children: [
          _DetailRow(
            label: controller.feeRowLabel,
            trailing: Text(controller.feeLabel, style: valueStyle),
            labelStyle: labelStyle,
          ),
          _DetailRow(
            label: 'membership_started'.tr,
            trailing: Text(controller.startedLabel, style: valueStyle),
            labelStyle: labelStyle,
          ),
          _DetailRow(
            label: 'membership_renewal'.tr,
            trailing: Text(controller.renewalLabel, style: valueStyle),
            labelStyle: labelStyle,
          ),
          Obx(
            () => _DetailRow(
              label: 'membership_auto_renew'.tr,
              trailing: AppFigmaSwitch(
                value: controller.autoRenew.value,
                onChanged: controller.setAutoRenew,
              ),
              labelStyle: labelStyle,
              showDivider: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.trailing,
    required this.labelStyle,
    this.showDivider = true,
  });

  final String label;
  final Widget trailing;
  final TextStyle labelStyle;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.dw(AppSpacing.t16)),
          child: Row(
            children: [
              Expanded(child: Text(label, style: labelStyle)),
              trailing,
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.surfaceCard),
      ],
    );
  }
}

class _IncludedCard extends GetView<MembershipManageController> {
  const _IncludedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
        border: Border.all(color: AppColors.surfaceCard, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0;
              i < MembershipManageController.includedBenefits.length;
              i++) ...[
            if (i > 0) SizedBox(height: context.dw(AppSpacing.t12)),
            _BulletRow(text: MembershipManageController.includedBenefits[i]),
          ],
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: context.dw(8)),
          child: Container(
            width: context.dw(5),
            height: context.dw(5),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: context.dw(AppSpacing.t10)),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(16),
              height: 1.3,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
