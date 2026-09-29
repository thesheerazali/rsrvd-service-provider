import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/partner_application/partner_application_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_notice_banner.dart';
import '../../widgets/primary_button.dart';

/// Final Review — Figma `1196:579`.
class PartnerApplicationReviewView
    extends GetView<PartnerApplicationController> {
  const PartnerApplicationReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final sectionGap = context.dw(AppSpacing.t30);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.auth,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const _Header(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t20),
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t40),
                  ),
                  children: [
                    Text(
                      'REVIEW APPLICATION',
                      style: GoogleFonts.cinzel(
                        fontWeight: FontWeight.w700,
                        fontSize: context.dw(24),
                        height: 1.2,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: sectionGap),
                    AppNoticeBanner(
                      message:
                          'Review your application before submitting it to the RSRVD review team.',
                    ),
                    SizedBox(height: sectionGap),
                    _ReviewCard(
                      title: 'Personal Information',
                      onEdit: () => controller.editSection(0),
                      fields: [
                        ('Name', controller.personalName),
                        ('Email', controller.personalEmail),
                        ('Phone', controller.personalPhone),
                      ],
                    ),
                    SizedBox(height: sectionGap),
                    _ReviewCard(
                      title: 'Basic Information',
                      onEdit: () => controller.editSection(0),
                      fields: [
                        (
                          'Primary Contact Name',
                          controller.primaryContactDisplay,
                        ),
                        (
                          'City',
                          controller.displayOrDash(
                            controller.cityController.text,
                          ),
                        ),
                        (
                          'State',
                          controller.displayOrDash(
                            controller.stateController.text,
                          ),
                        ),
                        (
                          'Country',
                          controller.displayOrDash(
                            controller.countryController.text,
                          ),
                        ),
                        ('Experience', controller.experienceDisplay),
                        ('Area of Expertise', controller.expertiseDisplay),
                        ('Service Areas', controller.serviceAreasDisplay),
                      ],
                    ),
                    SizedBox(height: sectionGap),
                    _ReviewCard(
                      title: 'Category',
                      onEdit: () => controller.editSection(1),
                      fields: [
                        ('Category', controller.categoryDisplay),
                      ],
                    ),
                    SizedBox(height: sectionGap),
                    _ReviewCard(
                      title: 'Documents & Verification',
                      onEdit: () => controller.editSection(2),
                      fields: [
                        (
                          PartnerApplicationController.docGovId,
                          controller.documentStatus(
                            PartnerApplicationController.docGovId,
                          ),
                        ),
                        (
                          PartnerApplicationController.docDriving,
                          controller.documentStatus(
                            PartnerApplicationController.docDriving,
                          ),
                        ),
                        (
                          PartnerApplicationController.docBusiness,
                          controller.documentStatus(
                            PartnerApplicationController.docBusiness,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sectionGap),
                    _ReviewCard(
                      title: 'NDA',
                      onEdit: () => controller.editSection(3),
                      fields: [
                        ('Signed by', controller.ndaSignedBy),
                        (
                          'Date',
                          controller.ndaSignedDateLabel.isEmpty
                              ? '-'
                              : controller.ndaSignedDateLabel,
                        ),
                        (
                          'Time',
                          controller.ndaSignedTimeLabel.isEmpty
                              ? '-'
                              : controller.ndaSignedTimeLabel,
                        ),
                        (
                          'NDA Version',
                          PartnerApplicationController.ndaVersion,
                        ),
                      ],
                    ),
                    SizedBox(height: sectionGap),
                    Obx(
                      () => PrimaryButton(
                        label: 'Submit Application',
                        enabled: !controller.isSubmitting.value,
                        onPressed: controller.submitApplication,
                      ),
                    ),
                    SizedBox(height: context.dw(AppSpacing.t10)),
                    Center(
                      child: GestureDetector(
                        onTap: Get.back,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          'Go Back',
                          style: GoogleFonts.darkerGrotesque(
                            fontWeight: FontWeight.w600,
                            fontSize: context.dw(24),
                            height: 1.2,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                        ),
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

class _Header extends StatelessWidget {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: Get.back,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.only(top: context.dw(AppSpacing.t08)),
              child: SvgPicture.asset(
                AppIcons.iconArrowLeft,
                width: context.dw(24),
                height: context.dw(24),
                colorFilter: ColorFilter.mode(
                  AppColors.text.withValues(alpha: 0.8),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: context.dw(AppSpacing.t10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PartnerApplicationController.screenTitle,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w600,
                    fontSize: context.dw(24),
                    height: 1.2,
                    color: AppColors.text.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  PartnerApplicationController.reviewHeaderSubtitle,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(18),
                    height: 1.2,
                    color: AppColors.text.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma card template `EL-a548d2cd` — `#181818`, 20 pad, 10 gap, radius 10.
class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.title,
    required this.onEdit,
    required this.fields,
  });

  final String title;
  final VoidCallback onEdit;
  final List<(String, String)> fields;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(20),
                    height: 1,
                    color: AppColors.primary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(
                  AppIcons.iconEdit,
                  width: context.dw(16),
                  height: context.dw(16),
                ),
              ),
            ],
          ),
          SizedBox(height: context.dw(AppSpacing.t10)),
          for (final field in fields)
            _ReviewRow(label: field.$1, value: field.$2),
        ],
      ),
    );
  }
}

/// Row with bottom `#242424` hairline — Figma `EL-26b8d096`.
class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(18),
      height: 1.2,
      color: AppColors.text,
    );
    final valueStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(18),
      height: 1.2,
      color: AppColors.white,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: context.dw(AppSpacing.t12)),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceCard, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: labelStyle),
          ),
          SizedBox(width: context.dw(AppSpacing.t10)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }
}
