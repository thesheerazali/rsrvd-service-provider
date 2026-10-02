import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/models/service_boost_plan.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/boost_service/boost_service_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_detail_back_header.dart';
import '../../widgets/primary_button.dart';

/// Boost This Service — Figma; selection cards match Membership plan cards.
class BoostServiceView extends GetView<BoostServiceController> {
  const BoostServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(
          child: Column(
            children: [
              AppDetailBackHeader(onBack: controller.goBack),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t20),
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'boost_service_title'.tr,
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.w600,
                          fontSize: context.dw(24),
                          height: 1.0,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      Obx(() {
                        return Text(
                          controller.serviceTitle.isEmpty
                              ? '—'
                              : controller.serviceTitle,
                          style: GoogleFonts.darkerGrotesque(
                            fontWeight: FontWeight.w500,
                            fontSize: context.dw(20),
                            height: 1.0,
                            color: AppColors.text.withValues(alpha: 0.6),
                          ),
                        );
                      }),
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
                              return _BoostPlanCard(
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
                        final submitting = controller.isSubmitting.value;
                        final hasSelection =
                            controller.selectedPlanId.value.isNotEmpty;
                        return PrimaryButton(
                          label: 'boost_service_continue'.tr,
                          enabled: !submitting && hasSelection,
                          onPressed: controller.continueWithSelected,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoostPlanCard extends StatelessWidget {
  const _BoostPlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final ServiceBoostPlan plan;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.title.toUpperCase(),
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(20),
                height: 1.0,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: context.dw(AppSpacing.t05)),
            Text(
              plan.description,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(16),
                height: 1,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
