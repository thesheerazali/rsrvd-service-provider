/// Spacing design tokens for consistent layout across the app.
///
/// Fixed logical-pixel values (no screen scaling). Prefer these over raw
/// magic numbers. Common Figma gaps observed: 5, 8, 10, 20, 40.
class AppSpacing {
  AppSpacing._();

  static const double t00 = 0;
  static const double t02 = 2;
  static const double t04 = 4;
  static const double t05 = 5;
  static const double t06 = 6;
  static const double t08 = 8;
  static const double t07 = 7;
  static const double t09 = 9;

  static const double t10 = 10;

  static const double t12 = 12;
  static const double t14 = 14;
  static const double t15 = 15;
  static const double t16 = 16;
  static const double t17 = 17;
  static const double t18 = 18;
  static const double t20 = 20;
  static const double t24 = 24;
  static const double t28 = 28;
  static const double t30 = 30;
  static const double t32 = 32;
  static const double t36 = 36;
  static const double t40 = 40;
  static const double t44 = 44;
  static const double t60 = 60;
  static const double t100 = 100;

  /// From Figma: cards ~8–10, sheets/modals ~20, phone frames ~40, pills ~100.
  static const double radiusXs = 6;
  static const double radiusSm = 8;
  static const double radiusMd = 10;
  static const double radiusLg = 20;
  static const double radiusXl = 40;
  static const double radiusPill = 100;
}
