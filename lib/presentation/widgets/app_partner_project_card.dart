import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/models/project_item.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Partners project list card — Figma `1196:4121`
/// (meta · title · member · amount · status pill).
class AppPartnerProjectCard extends StatelessWidget {
  const AppPartnerProjectCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final ProjectItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (tone, toneSurface) = switch (item.statusTone) {
      ProjectStatusTone.active || ProjectStatusTone.completed => (
          AppColors.success,
          AppColors.successSurface,
        ),
      ProjectStatusTone.cancelled => (
          AppColors.muted,
          const Color(0x0D818181),
        ),
      ProjectStatusTone.muted => (
          AppColors.error,
          AppColors.error.withValues(alpha: 0.08),
        ),
    };

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusLg)),
          border: Border.all(color: AppColors.surfaceCard),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.metaLine.isNotEmpty) ...[
                    Text(
                      item.metaLine,
                      style: GoogleFonts.darkerGrotesque(
                        fontWeight: FontWeight.w500,
                        fontSize: context.dw(16),
                        height: 1.0,
                        color: AppColors.text.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: context.dw(5)),
                  ],
                  Text(
                    item.title,
                    style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.w600,
                      fontSize: context.dw(18),
                      height: 1.2,
                      color: AppColors.text,
                    ),
                  ),
                  if (item.counterpartName.isNotEmpty) ...[
                    SizedBox(height: context.dw(5)),
                    Text(
                      item.counterpartName,
                      style: GoogleFonts.darkerGrotesque(
                        fontWeight: FontWeight.w500,
                        fontSize: context.dw(16),
                        height: 1.0,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                  if (item.amountLabel.isNotEmpty) ...[
                    SizedBox(height: context.dw(5)),
                    Text(
                      item.amountLabel,
                      style: GoogleFonts.darkerGrotesque(
                        fontWeight: FontWeight.w700,
                        fontSize: context.dw(16),
                        height: 1.0,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: context.dw(AppSpacing.t10)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.dw(AppSpacing.t15),
                vertical: context.dw(3),
              ),
              decoration: BoxDecoration(
                color: toneSurface,
                borderRadius:
                    BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: context.dw(3),
                    height: context.dw(3),
                    decoration: BoxDecoration(
                      color: tone,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: context.dw(3)),
                  Text(
                    item.status,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(14),
                      height: 1.0,
                      color: tone,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
