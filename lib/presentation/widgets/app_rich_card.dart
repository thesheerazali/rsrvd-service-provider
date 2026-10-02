import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/models/chat_message.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import '../../core/styles/app_spacing.dart';

/// Shared rich content card — same UI as Messages chat bubbles
/// (Investment / Real Estate / Concierge / Event / Contract).
///
/// Contract order (Figma preview): domain → title → summary → price →
/// date → location → attachment → status.
class AppRichCard extends StatelessWidget {
  const AppRichCard({
    super.key,
    required this.card,
    this.onCta,
  });

  final ChatRichCard card;
  final ValueChanged<ChatRichCard>? onCta;

  @override
  Widget build(BuildContext context) {
    final toneColor = switch (card.statusTone) {
      ChatStatusTone.review => AppColors.primary,
      ChatStatusTone.muted => AppColors.muted,
      ChatStatusTone.active => AppColors.success,
    };
    final toneSurface = switch (card.statusTone) {
      ChatStatusTone.review => AppColors.primary.withValues(alpha: 0.1),
      ChatStatusTone.muted => AppColors.surfaceCard,
      ChatStatusTone.active => AppColors.successSurface,
    };

    final metaStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(14),
      height: 1,
      color: AppColors.text.withValues(alpha: 1),
    );

    final inner = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          card.domainLabel,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w500,
            fontSize: context.dw(16),
            height: 1.0,
            color: AppColors.text.withValues(alpha: 0.5),
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t10)),
        Text(
          card.title.toUpperCase(),
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w500,
            fontSize: context.dw(20),
            height: 1.0,
            color: AppColors.primary,
          ),
        ),
        if (card.tags.isNotEmpty) ...[
          SizedBox(height: context.dw(AppSpacing.t10)),
          Text(card.tags, style: metaStyle),
        ],
        if (card.summary.isNotEmpty) ...[
          SizedBox(height: context.dw(AppSpacing.t10)),
          Text(
            card.summary,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(16),
              height: 1,
              color: AppColors.text,
            ),
          ),
        ],
        if (card.priceLine.isNotEmpty) ...[
          SizedBox(height: context.dw(AppSpacing.t10)),
          _PriceLine(priceLine: card.priceLine),
        ],
        if (card.dateLine.isNotEmpty) ...[
          SizedBox(height: context.dw(AppSpacing.t10)),
          Text(card.dateLine, style: metaStyle),
        ],
        if (card.location.isNotEmpty) ...[
          SizedBox(height: context.dw(AppSpacing.t10)),
          Text(card.location, style: metaStyle),
        ],
        if (card.footerLine.isNotEmpty) ...[
          SizedBox(height: context.dw(AppSpacing.t10)),
          Text(
            card.footerLine,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w600,
              fontSize: context.dw(14),
              height: 1.0,
              color: AppColors.primary,
            ),
          ),
        ],
        if (card.attachmentLabel.isNotEmpty) ...[
          SizedBox(height: context.dw(AppSpacing.t10)),
          Container(
            padding: EdgeInsets.all(context.dw(AppSpacing.t10)),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius:
                  BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppIcons.iconDoc,
                  width: context.dw(16),
                  height: context.dw(16),
                ),
                SizedBox(width: context.dw(5)),
                Flexible(
                  child: Text(
                    card.attachmentLabel,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(16),
                      height: 1,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (card.statusLabel.isNotEmpty) ...[
          SizedBox(height: context.dw(AppSpacing.t10)),
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
                    color: toneColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: context.dw(5)),
                Text(
                  card.statusLabel,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(14),
                    height: 1,
                    color: toneColor,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (card.hasCta && onCta != null) ...[
          SizedBox(height: context.dw(AppSpacing.t16)),
          SizedBox(
            width: double.infinity,
            height: context.dw(48),
            child: Material(
              color: AppColors.primary,
              borderRadius:
                  BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
              child: InkWell(
                onTap: () => onCta!(card),
                borderRadius:
                    BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
                child: Center(
                  child: Text(
                    card.ctaLabel,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w600,
                      fontSize: context.dw(18),
                      height: 1.0,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );

    if (!card.isEventLayout) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
          border: Border.all(color: AppColors.surfaceCard),
        ),
        child: inner,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (card.overlayLabel.isNotEmpty)
          Text(
            card.overlayLabel,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(14),
              height: 1.0,
              color: AppColors.text.withValues(alpha: 0.6),
            ),
          ),
        if (card.overlayLabel.isNotEmpty)
          SizedBox(height: context.dw(AppSpacing.t10)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius:
                BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
            border: Border.all(color: AppColors.surfaceCard),
          ),
          child: inner,
        ),
      ],
    );
  }
}

/// `$20000` in primary; `/Fixed Price` muted — Figma contract preview.
class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.priceLine});

  final String priceLine;

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w700,
      fontSize: context.dw(16),
      height: 1.2,
      color: AppColors.primary,
    );
    final slash = priceLine.indexOf('/');
    if (slash <= 0 || slash >= priceLine.length - 1) {
      return Text(priceLine, style: base);
    }
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: priceLine.substring(0, slash)),
          TextSpan(
            text: priceLine.substring(slash),
            style: base.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: context.dw(16),
              height: 1,
              color: AppColors.primary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
