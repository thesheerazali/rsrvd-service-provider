import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/partner_terms/partner_terms_controller.dart';
import '../../widgets/app_back_title_header.dart';
import '../../widgets/app_background.dart';

/// Settings → Partner Terms.
class PartnerTermsView extends GetView<PartnerTermsController> {
  const PartnerTermsView({super.key});

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
                title: 'settings_partner_terms'.tr,
                onBack: controller.goBack,
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t20),
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t40),
                  ),
                  itemCount: PartnerTermsController.sections.length,
                  separatorBuilder: (_, _) =>
                      SizedBox(height: context.dw(AppSpacing.t20)),
                  itemBuilder: (context, index) {
                    final section = PartnerTermsController.sections[index];
                    return _TermsSection(section: section);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({required this.section});

  final PartnerTermsSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w700,
            fontSize: context.dw(20),
            height: 1.0,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t10)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius:
                BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
            border: Border.all(color: AppColors.surfaceCard, width: 0.5),
          ),
          child: Text(
            section.body,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(16),
              height: 1.2,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
