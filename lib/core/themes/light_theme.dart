import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';
import '../styles/typography.dart';

/// Dark-first theme matching the RSRVD Figma (ink `#111111` + primary `#CC5500`).
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: AppTypography.bodyFamily,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.bg,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.accent,
    onSecondary: AppColors.white,
    surface: AppColors.surface,
    onSurface: AppColors.text,
    error: AppColors.error,
  ),
  textTheme: TextTheme(
    displayLarge: AppTypography.displayLarge,
    displayMedium: AppTypography.displayMedium,
    displaySmall: AppTypography.displaySmall,
    titleLarge: AppTypography.title,
    titleMedium: AppTypography.subtitle,
    bodyLarge: AppTypography.bodyMedium,
    bodyMedium: AppTypography.bodyRegular,
    bodySmall: AppTypography.fieldLabel,
    labelLarge: AppTypography.button,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.bg,
    foregroundColor: AppColors.text,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTypography.displaySmall,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      textStyle: GoogleFonts.darkerGrotesque(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.2,
      ),
    ),
  ),
  dividerColor: AppColors.border,
);
