import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/models/partner_service.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import '../../core/styles/app_spacing.dart';

/// Reusable partner service card — Figma Services `1196:1524`+.
///
/// Customize via flags / callbacks for Home previews, My Services, etc.
class AppServiceCard extends StatelessWidget {
  const AppServiceCard({
    super.key,
    required this.service,
    this.showActions = true,
    this.showBoostButton = true,
    this.onEdit,
    this.onDelete,
    this.onBoost,
    this.onTap,
  });

  final PartnerService service;

  /// Edit / delete icon column (My Services).
  final bool showActions;

  /// Outlined Boost CTA when [PartnerService.canBoost].
  final bool showBoostButton;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onBoost;
  final VoidCallback? onTap;

  static const Color _publishedFill = Color(0x0D70FF85);
  static const Color _publishedText = Color(0xFF1CBF73);
  static const Color _boostedFill = Color(0x0DB38922);

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
          border: Border.all(color: AppColors.surfaceCard),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BadgesRow(service: service),
                  SizedBox(height: context.dw(AppSpacing.t05)),
                  Text(
                    service.category,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(16),
                      height: 1.0,
                      color: AppColors.text.withValues(alpha: 0.5),
                    ),
                  ),
                  SizedBox(height: context.dw(AppSpacing.t05)),
                  Text(
                    service.title,
                    style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.w600,
                      fontSize: context.dw(20),
                      height: 1.0,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: context.dw(AppSpacing.t05)),
                  Text(
                    service.description,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(16),
                      height: 1.0,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: context.dw(AppSpacing.t05)),
                  Text(
                    service.priceLabel,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w700,
                      fontSize: context.dw(16),
                      height: 1.0,
                      color: AppColors.primary,
                    ),
                  ),
                  if (showBoostButton && service.canBoost) ...[
                    SizedBox(height: context.dw(AppSpacing.t10)),
                    _BoostButton(onTap: onBoost),
                  ],
                ],
              ),
            ),
            if (showActions) ...[
              SizedBox(width: context.dw(AppSpacing.t10)),
              _ActionColumn(onEdit: onEdit, onDelete: onDelete),
            ],
          ],
        ),
      ),
    );
  }
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({required this.service});

  final PartnerService service;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.dw(AppSpacing.t05),
      runSpacing: context.dw(AppSpacing.t05),
      children: [
        if (service.isPublished)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.dw(AppSpacing.t15),
              vertical: context.dw(AppSpacing.t03),
            ),
            decoration: BoxDecoration(
              color: AppServiceCard._publishedFill,
              borderRadius:
                  BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: context.dw(3),
                  height: context.dw(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppServiceCard._publishedText,
                  ),
                ),
                SizedBox(width: context.dw(AppSpacing.t03)),
                Text(
                  'Published',
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(14),
                    height: 1.0,
                    color: AppServiceCard._publishedText,
                  ),
                ),
              ],
            ),
          ),
        if (service.isBoosted)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.dw(AppSpacing.t15),
              vertical: context.dw(AppSpacing.t03),
            ),
            decoration: BoxDecoration(
              color: AppServiceCard._boostedFill,
              borderRadius:
                  BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppIcons.iconBoostEnergy,
                  width: context.dw(10),
                  height: context.dw(10),
                ),
                SizedBox(width: context.dw(AppSpacing.t02)),
                Text(
                  'Boosted',
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(14),
                    height: 1.0,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _BoostButton extends StatelessWidget {
  const _BoostButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.dw(96),
        height: context.dw(40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          'Boost',
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w600,
            fontSize: context.dw(18),
            height: 1.2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _ActionColumn extends StatelessWidget {
  const _ActionColumn({this.onEdit, this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onEdit,
          behavior: HitTestBehavior.opaque,
          child: Opacity(
            opacity: 0.5,
            child: SvgPicture.asset(
              AppIcons.iconEdit,
              width: context.dw(18),
              height: context.dw(18),
              colorFilter: const ColorFilter.mode(
                AppColors.text,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(width: context.dw(AppSpacing.t10)),
        GestureDetector(
          onTap: onDelete,
          behavior: HitTestBehavior.opaque,
          child: Opacity(
            opacity: 0.5,
            child: SvgPicture.asset(
              AppIcons.iconDelete,
              width: context.dw(18),
              height: context.dw(18),
              colorFilter: const ColorFilter.mode(
                AppColors.text,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
