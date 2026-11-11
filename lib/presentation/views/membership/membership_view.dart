import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/models/membership_plan.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/membership/membership_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/primary_button.dart';

/// Choose A Plan — Access / Featured / National.
class MembershipView extends GetView<MembershipController> {
  const MembershipView({super.key});

  /// Badge fill `rgba(201, 180, 143, 0.1)`.
  static const Color _badgeBg = AppColors.primarySurface;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.auth,
        child: SafeArea(
          maintainBottomViewPadding: true,
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
                  'membership_title'.tr.toUpperCase(),
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    fontSize: context.dw(32),
                    height: 1.0,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t10)),
                Text(
                  'membership_subtitle'.tr,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(20),
                    height: 1.2,
                    color: AppColors.accentGold,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                Expanded(
                  child: Obx(() {
                    final selectedId = controller.selectedPlanId.value;
                    final plans = controller.plans.toList();
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: plans.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: context.dw(AppSpacing.t10)),
                      itemBuilder: (context, index) {
                        final plan = plans[index];
                        return _PlanCard(
                          plan: plan,
                          selected: selectedId == plan.id,
                          onTap: () => controller.selectPlan(plan.id),
                        );
                      },
                    );
                  }),
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                Obx(() {
                  final selectedId = controller.selectedPlanId.value;
                  final submitting = controller.isSubmitting.value;
                  return PrimaryButton(
                    label: controller.continueLabel,
                    enabled: !submitting && selectedId.isNotEmpty,
                    onPressed: controller.continueWithSelectedPlan,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Plan card — Access / Featured / National.
///
/// Outer: pad 20, radius 20, stroke primary (selected) or `#242424`.
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final MembershipPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusLg)),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.surfaceCard,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Price stays top-right; badge/title stack on the left.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (plan.badgeLabel != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.dw(AppSpacing.t15),
                            vertical: context.dw(AppSpacing.t03),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(
                              context.dw(AppSpacing.radiusPill),
                            ),
                          ),
                          child: Text(
                            plan.badgeLabel!,
                            style: GoogleFonts.darkerGrotesque(
                              fontWeight: FontWeight.w500,
                              fontSize: context.dw(14),
                              height: 1.0,
                              color: AppColors.accentGold,
                            ),
                          ),
                        ),
                        SizedBox(height: context.dw(AppSpacing.t10)),
                      ],
                      Text(
                        plan.name.toUpperCase(),
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.w600,
                          fontSize: context.dw(20),
                          height: 1,
                          color: AppColors.primary,
                        ),
                      ),
                      if (plan.constraintNote != null) ...[
                        SizedBox(height: context.dw(AppSpacing.t04)),
                        Text(
                          plan.constraintNote!,
                          style: GoogleFonts.darkerGrotesque(
                            fontWeight: FontWeight.w500,
                            fontSize: context.dw(12),
                            height: 1.2,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: context.dw(AppSpacing.t10)),
                _PriceBlock(plan: plan),
              ],
            ),
            if (plan.tagline != null) ...[
              SizedBox(height: context.dw(AppSpacing.t10)),
              Text(
                plan.tagline!,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: context.dw(16),
                  height: 1,
                  color: AppColors.accentGold,
                ),
              ),
            ],
            if (plan.features.isNotEmpty) ...[
              SizedBox(height: context.dw(AppSpacing.t10)),
              for (var i = 0; i < plan.features.length; i++) ...[
                if (i > 0) SizedBox(height: context.dw(AppSpacing.t05)),
                _FeatureRow(text: plan.features[i]),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// Price block — `$2,499 yearly` + `$208/month`.
class _PriceBlock extends StatelessWidget {
  const _PriceBlock({required this.plan});

  final MembershipPlan plan;

  @override
  Widget build(BuildContext context) {
    final amountStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w700,
      fontSize: context.dw(24),
      height: 1.0,
      color: AppColors.accentGold,
    );
    final periodStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(14),
      height: 1.2,
      color: AppColors.accentGold,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text.rich(
          textAlign: TextAlign.right,
          TextSpan(
            children: [
              TextSpan(text: plan.priceFormatted, style: amountStyle),
              TextSpan(text: plan.periodLabel, style: amountStyle),
            ],
          ),
        ),
        if (plan.secondaryPriceCents != null)
          Text(
            '${plan.secondaryPriceFormatted}/month',
            textAlign: TextAlign.right,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w600,
              fontSize: context.dw(14),
              height: 1.2,
              color: AppColors.accentGold,
            ),
          ),
      ],
    );
  }
}

/// Feature row — sparkle 10×10 + DG Medium 14.
class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.dw(AppSpacing.t03)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.dw(2)),
            child: SvgPicture.asset(
              AppIcons.sparkle,
              width: context.dw(10),
              height: context.dw(10),
            ),
          ),
          SizedBox(width: context.dw(AppSpacing.t02)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(14),
                height: 1,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
