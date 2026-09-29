import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Soft primary notice strip — same token as Partner Review
/// (`rgba(250, 74, 24, 0.05)`, DG Medium 16, primary text).
class AppNoticeBanner extends StatelessWidget {
  const AppNoticeBanner({
    super.key,
    required this.message,
    this.textAlign = TextAlign.start,
  });

  /// Banner fill `rgba(250, 74, 24, 0.05)`.
  static const Color fill = Color(0x0DFA4A18);

  final String message;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.dw(AppSpacing.t20),
        vertical: context.dw(AppSpacing.t10),
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
      ),
      child: Text(
        message,
        textAlign: textAlign,
        style: GoogleFonts.darkerGrotesque(
          fontWeight: FontWeight.w500,
          fontSize: context.dw(16),
          height: 1.2,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
