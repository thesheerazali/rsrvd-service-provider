import 'package:flutter/material.dart';

/// RSRVD brand colors from Figma — kept in sync with Elite
/// (file `WkuW1xGtSDJdEMim7zX3oB` — Authentication / branding).
///
/// Dark walnut `#1D130B` + champagne gold `#C9B48F`. Screens are dark-first.
class AppColors {
  AppColors._();

  // Brand
  /// Primary — accents, icons, emphasis text.
  static const Color primary = Color(0xFFC9B48F);

  /// Deeper primary — pressed / tonal accents.
  static const Color primaryDark = Color(0xFFC9B48F);

  /// Soft cream — filled CTAs (Figma auth button `#F5EEE0`).
  static const Color accentGold = Color(0xFFF5EEE0);

  /// Soft primary wash — primary @ 10%.
  static const Color primarySurface = Color(0x1AC9B48F);

  /// Secondary accent (same brand gold).
  static const Color accent = Color(0xFFC9B48F);

  // Neutrals — dark walnut UI
  static const Color white = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1D130B);
  static const Color bg = Color(0xFF1D130B);
  static const Color surface = Color(0xFF241A12); // modals / sheets
  static const Color surfaceRaised = Color(0xFF2C2018);
  static const Color surfaceMuted = Color(0xFF32261E);
  static const Color surfaceCard = Color(0xFF242424);
  static const Color border = Color(0x1AFFFFFF); // white @ 10%

  /// Primary text on dark backgrounds (brand gold).
  static const Color text = Color(0xFFC9B48F);

  /// Stronger cream for titles / buttons on dark.
  static const Color textStrong = Color(0xFFF5EEE0);

  /// Secondary / muted copy (gold @ 50%).
  static const Color subtext = Color(0x80C9B48F);

  /// Explicit muted gray used for inactive labels.
  static const Color muted = Color(0xFF818181);

  // Semantic
  static const Color success = Color(0xFF70FF85);
  static const Color successSurface = Color(0x0D70FF85); // green @ 5%
  static const Color error = Color(0xFFF92222);
  static const Color errorAlt = Color(0xFFEB4335); // Google / destructive alt
  static const Color info = Color(0xFF4285F4);

  /// Text / icons on filled cream or gold CTAs.
  static const Color onPrimary = Color(0xFF1D130B);
}
