import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';
import 'primary_button.dart';

/// Shared empty-state pattern (Services, Messages, etc.).
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.body,
    required this.ctaLabel,
    required this.onCtaPressed,
    this.imageWidth = 37,
    this.imageHeight = 35,
  });

  final String imageAsset;
  final String title;
  final String body;
  final String ctaLabel;
  final VoidCallback onCtaPressed;
  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: context.dw(62),
          height: context.dw(62),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFB38922).withValues(alpha: 0.1),
          ),
          alignment: Alignment.center,
          child: Image.asset(
            imageAsset,
            width: context.dw(imageWidth),
            height: context.dw(imageHeight),
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t20)),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w700,
            fontSize: context.dw(24),
            height: 1.0,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t10)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t20)),
          child: Text(
            body,
            textAlign: TextAlign.center,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(20),
              height: 1.0,
              color: AppColors.text,
            ),
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t20)),
        PrimaryButton(
          label: ctaLabel,
          onPressed: onCtaPressed,
        ),
      ],
    );
  }
}
