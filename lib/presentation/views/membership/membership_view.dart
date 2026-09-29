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

/// Choose A Plan — Figma Member Screen `1196:132` (single full-screen fetch).
class MembershipView extends GetView<MembershipController> {
  const MembershipView({super.key});

  /// Badge fill `rgba(179, 137, 34, 0.05)`.
  static const Color _badgeBg = Color(0x0DB38922);

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
            // Figma #1196:160 — column, gap 30, width 380.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // #1196:161 — title stack, gap 10.
                Text(
                  'membership_title'.tr,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    fontSize: context.dw(32),
                    height: 1.0,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t10)),
                Text(
                  'membership_subtitle'.tr,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(20),
                    height: 1.0,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                // #1196:164 — plans column, gap 10.
                Expanded(
                  child: Obx(() {
                    // Read rx values here (not only in itemBuilder) so Obx
                    // tracks selection — ListView builds children lazily.
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
                // #1196:230 — Continue with Annual / Monthly.
                Obx(() {
                  final selectedId = controller.selectedPlanId.value;
                  final submitting = controller.isSubmitting.value;
                  final plan = controller.selectedPlan;
                  return PrimaryButton(
                    label: plan?.continueCtaLabel ?? 'Continue with Annual',
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

/// Plan card — Figma `#1196:165` / `#1196:198`.
///
/// Outer: pad 20, radius 20, stroke primary (selected) or `#242424`.
/// Inner column gap 10: optional badge → title/price row → features (gap 5).
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
            if (plan.badgeLabel != null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dw(AppSpacing.t15),
                    vertical: context.dw(AppSpacing.t03),
                  ),
                  decoration: BoxDecoration(
                    color: MembershipView._badgeBg,
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
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.dw(AppSpacing.t10)),
            ],
            // #1196:169 — row gap 10: title | price.
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(20),
                      height: 1.0,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: context.dw(AppSpacing.t10)),
                _PriceBlock(plan: plan),
              ],
            ),
            if (plan.features.isNotEmpty) ...[
              SizedBox(height: context.dw(AppSpacing.t10)),
              // #1196:173 — features column gap 5.
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

/// Price block — Figma `#1196:172` / `#1196:203`.
///
/// Base DG Bold 16 primary; amount override 24; period Medium 16;
/// secondary line SemiBold 14 (` $450/month`).
class _PriceBlock extends StatelessWidget {
  const _PriceBlock({required this.plan});

  final MembershipPlan plan;

  @override
  Widget build(BuildContext context) {
    final amountStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w700,
      fontSize: context.dw(24),
      height: 1.0,
      color: AppColors.primary,
    );
    final periodStyle = GoogleFonts.darkerGrotesque(
      // Yearly `/year` = Medium (ts2); Monthly `/Monthly` = Bold 16 base.
      fontWeight: plan.interval == MembershipBillingInterval.yearly
          ? FontWeight.w500
          : FontWeight.w700,
      fontSize: context.dw(16),
      height: 1.0,
      color: AppColors.primary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text.rich(
          textAlign: TextAlign.right,
          TextSpan(
            children: [
              TextSpan(text: plan.priceFormatted, style: amountStyle),
              TextSpan(text: plan.periodLabel, style: periodStyle),
            ],
          ),
        ),
        if (plan.secondaryPriceCents != null)
          Text(
            ' ${plan.secondaryPriceFormatted}/month',
            textAlign: TextAlign.right,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w600,
              fontSize: context.dw(14),
              height: 1.2,
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }
}

/// Feature row — Figma `#1196:174`: pad 3 0, gap 2, sparkle 10×10 + DG Medium 14.
class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.dw(AppSpacing.t03)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.sparkle,
            width: context.dw(10),
            height: context.dw(10),
          ),
          SizedBox(width: context.dw(AppSpacing.t02)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(14),
                height: 1.0,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
