import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/help_support/help_support_controller.dart';
import '../../widgets/app_back_title_header.dart';
import '../../widgets/app_background.dart';

/// Settings → Help & Support — same Elite layout; Partner FAQ content.
class HelpSupportView extends GetView<HelpSupportController> {
  const HelpSupportView({super.key});

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
                title: 'settings_help'.tr,
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
                    const _IntroCard(),
                    SizedBox(height: context.dw(AppSpacing.t10)),
                    for (final faq in HelpSupportController.faqs) ...[
                      _FaqTile(item: faq),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                    ],
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

class _IntroCard extends GetView<HelpSupportController> {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    final body = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w600,
      fontSize: context.dw(20),
      height: 1.0,
      color: AppColors.white,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
        border: Border.all(color: AppColors.surfaceCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need assistance? Our team is here to help with your requests and '
            'questions.',
            style: body,
          ),
          SizedBox(height: context.dw(AppSpacing.t10)),
          GestureDetector(
            onTap: controller.chatWithSupport,
            behavior: HitTestBehavior.opaque,
            child: Text('  - Chat with Support', style: body),
          ),
          SizedBox(height: context.dw(AppSpacing.t05)),
          GestureDetector(
            onTap: controller.emailSupport,
            behavior: HitTestBehavior.opaque,
            child: Text('  - Email Support', style: body),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends GetView<HelpSupportController> {
  const _FaqTile({required this.item});

  final HelpFaqItem item;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expanded = controller.expandedId.value == item.id;
      return GestureDetector(
        onTap: () => controller.toggleFaq(item.id),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: context.dw(AppSpacing.t05),
            vertical: context.dw(AppSpacing.t10),
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius:
                BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
            border: Border.all(color: AppColors.surfaceCard, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: SvgPicture.asset(
                      AppIcons.iconChevronDown,
                      width: context.dw(16),
                      height: context.dw(30),
                    ),
                  ),
                  SizedBox(width: context.dw(AppSpacing.t05)),
                  Expanded(
                    child: Text(
                      item.question,
                      style: GoogleFonts.darkerGrotesque(
                        fontWeight: FontWeight.w500,
                        fontSize: context.dw(20),
                        height: 1.0,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
              if (expanded) ...[
                SizedBox(height: context.dw(AppSpacing.t10)),
                Padding(
                  padding: EdgeInsets.only(left: context.dw(21)),
                  child: Text(
                    item.answer,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: context.dw(18),
                      height: 1.2,
                      color: AppColors.text.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
