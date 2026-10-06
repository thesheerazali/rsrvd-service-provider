import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Partner NDA body card — onboarding Step 4 + Settings → Signed NDA.
class AppNdaBodyCard extends StatelessWidget {
  const AppNdaBodyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.dw(AppSpacing.t20),
        vertical: context.dw(AppSpacing.t10),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'pa_nda_card_title'.tr,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(16),
              height: 1.2,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: context.dw(AppSpacing.t12)),
          Text(
            'pa_nda_body'.tr,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(16),
              height: 1.2,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// Signature meta that expands under the NDA accept control in onboarding,
/// and is always shown on Settings → Signed NDA.
class AppNdaSignatureDetails extends StatelessWidget {
  const AppNdaSignatureDetails({
    super.key,
    required this.signedBy,
    required this.date,
    required this.time,
    required this.version,
  });

  final String signedBy;
  final String date;
  final String time;
  final String version;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('pa_nda_signed_by'.tr, signedBy),
      ('pa_nda_date'.tr, date),
      ('pa_nda_time'.tr, time),
      ('pa_nda_version'.tr, version),
    ];

    final style = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(20),
      height: 1.2,
      color: AppColors.text,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.dw(AppSpacing.t20),
        vertical: context.dw(AppSpacing.t08),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: context.dw(AppSpacing.t14)),
              child: Row(
                children: [
                  Expanded(child: Text(rows[i].$1, style: style)),
                  Text(rows[i].$2, style: style),
                ],
              ),
            ),
          //  if (i != rows.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.surfaceCard,
              ),
          ],
        ],
      ),
    );
  }
}
