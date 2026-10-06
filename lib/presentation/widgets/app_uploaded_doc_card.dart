import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/models/partner_uploaded_document.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import '../../core/styles/app_spacing.dart';

/// Uploaded verification doc card — Figma Partner Application step 3.
class AppUploadedDocCard extends StatelessWidget {
  const AppUploadedDocCard({
    super.key,
    required this.document,
    required this.onRetry,
    required this.onDelete,
    this.iconColor = AppColors.white,
    this.textColor = AppColors.white,
    
  });

  final PartnerUploadedDocument document;
  final VoidCallback onRetry;
  final VoidCallback onDelete;
  final Color? iconColor;
  final Color? textColor;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.dw(AppSpacing.t20),
        vertical: context.dw(AppSpacing.t16),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusLg)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.fileName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(16),
                    height: 1.2,
                    color: textColor,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t04)),
                Text(
                  document.metaLine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(16),
                    height: 1.2,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.dw(AppSpacing.t12)),
          GestureDetector(
            onTap: onRetry,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(context.dw(AppSpacing.t04)),
              child: SvgPicture.asset(
                AppIcons.iconExchange,
                width: context.dw(18),
                height: context.dw(18),
                colorFilter: ColorFilter.mode(
                  iconColor!,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(context.dw(AppSpacing.t04)),
              child: SvgPicture.asset(
                AppIcons.iconDelete,
                width: context.dw(18),
                height: context.dw(18),
                colorFilter: ColorFilter.mode(
                  iconColor!,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
