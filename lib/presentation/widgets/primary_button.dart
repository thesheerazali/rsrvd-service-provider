import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Figma primary CTA — cream pill `#F5EEE0`, dark walnut label, 50h, full width.
///
/// Set [outlined] for secondary actions (transparent fill, gold border + text).
/// Optional [color] overrides the default cream/gold fill (e.g. destructive).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.outlined = false,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool outlined;

  /// Defaults to cream [AppColors.accentGold] (filled) / gold border (outlined).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.dw(AppSpacing.radiusPill));
    final fill = color ?? AppColors.accentGold;
    final outline = color ?? AppColors.accentGold;
    final textStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w600,
      fontSize: context.dw(24),
      color: outlined ? AppColors.accentGold : AppColors.onPrimary,
      height: 1.2,
    );

    return SizedBox(
      width: double.infinity,
      height: context.dw(50),
      child: outlined
          ? OutlinedButton(
              onPressed: enabled ? onPressed : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: color ?? AppColors.primary,
                disabledForegroundColor:
                    outline.withValues(alpha: 0.4),
                side: BorderSide(
                  color: enabled ? outline : outline.withValues(alpha: 0.4),
                ),
                shape: RoundedRectangleBorder(borderRadius: radius),
                textStyle: textStyle,
              ),
              child: Text(label, style: textStyle),
            )
          : ElevatedButton(
              onPressed: enabled ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: fill,
                disabledBackgroundColor: fill.withValues(alpha: 0.4),
                foregroundColor: color == null
                    ? AppColors.onPrimary
                    : AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: radius,
                  side: BorderSide(color: fill),
                ),
                textStyle: textStyle,
              ),
              child: Text(label),
            ),
    );
  }
}
