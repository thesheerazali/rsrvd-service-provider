import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/models/partner_review.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/reviews/reviews_controller.dart';
import '../../widgets/app_background.dart';

/// Settings → Rating & Reviews — Figma `1196:3579`.
class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});

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
              const _Header(),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
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
                      const _SummaryCard(),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      Text(
                        'reviews_members_feedback'.tr,
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.w700,
                          fontSize: context.dw(24),
                          height: 1.2,
                          color: AppColors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      for (var i = 0; i < controller.reviews.length; i++) ...[
                        _ReviewRow(item: controller.reviews[i]),
                        if (i != controller.reviews.length - 1)
                          SizedBox(height: context.dw(AppSpacing.t10)),
                      ],
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends GetView<ReviewsController> {
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
            'reviews_title'.tr,
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

class _SummaryCard extends GetView<ReviewsController> {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusLg)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              controller.averageLabel.value,
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(20),
                height: 1.0,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: context.dw(AppSpacing.t10)),
          Obx(
            () => Text(
              controller.countLabel.value,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(16),
                height: 1.0,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.item});

  final PartnerReview item;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.white.withValues(alpha: 0.5);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.dw(AppSpacing.t20),
        vertical: context.dw(AppSpacing.t10),
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceCard, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(14),
                    height: 1.0,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t02)),
                Text(
                  item.ratingLabel,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(16),
                    height: 1.0,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t02)),
                Text(
                  item.body,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(16),
                    height: 1.0,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t02)),
                Text(
                  item.authorName,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(14),
                    height: 1.0,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.dw(AppSpacing.t10)),
          SizedBox(
            width: context.dw(80),
            child: Text(
              item.dateLabel,
              textAlign: TextAlign.right,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(14),
                height: 1.0,
                color: muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
