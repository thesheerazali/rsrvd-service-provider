import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// RSRVD type scale from Figma.
///
/// - **Cinzel** — display / titles (often `textCase: UPPER`)
/// - **Darker Grotesque** — body, buttons, UI chrome
///
/// Weights used in design: 400, 500, 600, 700.
/// Common sizes: 12, 14, 16, 18, 20, 24, 28, 32.
class AppTypography {
  AppTypography._();

  static const String displayFamily = 'Cinzel';
  static const String bodyFamily = 'Darker Grotesque';

  /// Prefer [display] / [body] helpers so Google Fonts load correctly.
  /// Kept for ThemeData.fontFamily fallback.
  static String? get fontFamily => bodyFamily;

  // --- Display (Cinzel) ---

  /// Hero / splash wordmark — Cinzel Medium 32 / lh 1.2 / UPPER.
  static TextStyle get displayLarge => GoogleFonts.cinzel(
        fontWeight: FontWeight.w500,
        fontSize: 32,
        height: 1.2,
        color: AppColors.text,
      );

  /// Section titles — Cinzel Regular/Medium 24 / lh 1.2 / UPPER.
  static TextStyle get displayMedium => GoogleFonts.cinzel(
        fontWeight: FontWeight.w500,
        fontSize: 24,
        height: 1.2,
        color: AppColors.text,
      );

  /// Smaller display — Cinzel Medium 18–20.
  static TextStyle get displaySmall => GoogleFonts.cinzel(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        height: 1.0,
        color: AppColors.text,
      );

  // --- Body (Darker Grotesque) ---

  /// Large UI title — SemiBold/Bold 28.
  static TextStyle get title => GoogleFonts.darkerGrotesque(
        fontWeight: FontWeight.w700,
        fontSize: 28,
        height: 1.2,
        color: AppColors.text,
      );

  /// Subtitle / lead — Regular/Medium 20 / lh 1.2.
  static TextStyle get subtitle => GoogleFonts.darkerGrotesque(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        height: 1.2,
        color: AppColors.subtext,
      );

  /// Emphasized body — Medium 16–18.
  static TextStyle get bodyMedium => GoogleFonts.darkerGrotesque(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.2,
        color: AppColors.text,
      );

  /// Default body — Regular 16–18.
  static TextStyle get bodyRegular => GoogleFonts.darkerGrotesque(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.2,
        color: AppColors.subtext,
      );

  /// Captions / meta — Medium 14.
  static TextStyle get fieldLabel => GoogleFonts.darkerGrotesque(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.0,
        color: AppColors.subtext,
      );

  /// Primary button label — SemiBold 20–24, usually on gold.
  static TextStyle get button => GoogleFonts.darkerGrotesque(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.2,
        color: AppColors.onPrimary,
      );

  /// Alias used by older scaffold docs — maps to [displayMedium].
  static TextStyle get heading => displayMedium;
}
