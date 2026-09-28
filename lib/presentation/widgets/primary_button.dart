import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Figma primary CTA — orange pill, 50h, full width.
///
/// Set [outlined] for secondary actions (transparent fill, orange border + text).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.dw(AppSpacing.radiusPill));
    final textStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w600,
      fontSize: context.dw(24),
      height: 1.2,
    );

    return SizedBox(
      width: double.infinity,
      height: context.dw(50),
      child: outlined
          ? OutlinedButton(
              onPressed: enabled ? onPressed : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                disabledForegroundColor:
                    AppColors.accent.withValues(alpha: 0.4),
                side: BorderSide(
                  color: enabled
                      ? AppColors.accent
                      : AppColors.accent.withValues(alpha: 0.4),
                ),
                shape: RoundedRectangleBorder(borderRadius: radius),
                textStyle: textStyle,
              ),
              child: Text(label),
            )
          : ElevatedButton(
              onPressed: enabled ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                disabledBackgroundColor:
                    AppColors.accent.withValues(alpha: 0.4),
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: radius,
                  side: const BorderSide(color: AppColors.accent),
                ),
                textStyle: textStyle,
              ),
              child: Text(label),
            ),
    );
  }
}
