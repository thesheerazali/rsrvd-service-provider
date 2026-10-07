import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import '../../core/styles/app_spacing.dart';
import 'golden_top_glow.dart';
import 'primary_button.dart';

/// Reusable confirm sheet — Figma `1001:2798`.
///
/// Includes the two soft gold glow layers (opacity ~0.2) and outer elevation
/// shadow from that frame. Use [AppConfirmDialog.show] from any feature.
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.eyebrow = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.titleColor,
    this.confirmColor,
    this.cancelColor,
    this.onConfirm,
    this.onCancel,
  });

  final String eyebrow;
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  /// Defaults to white (Elite confirm). Publish success uses [AppColors.primary].
  final Color? titleColor;
  /// Defaults to [AppColors.accent] (filled primary CTA).
  final Color? confirmColor;
  /// Defaults to [AppColors.accent] (outlined cancel).
  final Color? cancelColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  /// Returns `true` if confirm was pressed, `false` if cancel, `null` if dismissed.
  static Future<bool?> show({
    required String title,
    required String message,
    required String confirmLabel,
    String eyebrow = 'Confirm',
    String cancelLabel = 'Cancel',
    Color? titleColor,
    Color? confirmColor,
    Color? cancelColor,
    bool barrierDismissible = true,
  }) {
    return Get.dialog<bool>(
      AppConfirmDialog(
        eyebrow: eyebrow,
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        titleColor: titleColor,
        confirmColor: confirmColor,
        cancelColor: cancelColor,
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.72),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = context.dw(AppSpacing.radiusLg);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t30)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.55),
              blurRadius: context.dw(40),
              offset: Offset(0, context.dw(12)),
            ),
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.22),
              blurRadius: context.dw(48),
              spreadRadius: context.dw(-4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: ColoredBox(
            color: AppColors.surface,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                if (GoldenTopGlow.showGlow) ...[
                  // Figma #1001:2799 — top gold wash @ 0.2
                  Positioned(
                    left: context.dw(-27),
                    top: context.dw(-220),
                    width: context.dw(420),
                    height: context.dw(320),
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.35,
                        child: Image.asset(
                          AppImages.glowTop,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                  // Figma #1001:2803 — side / corner spill @ 0.2
                  Positioned(
                    right: context.dw(-160),
                    top: context.dw(-80),
                    width: context.dw(360),
                    height: context.dw(360),
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.28,
                        child: Image.asset(
                          AppImages.glowTop,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.dw(25),
                    context.dw(AppSpacing.t40),
                    context.dw(25),
                    context.dw(AppSpacing.t40),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        eyebrow,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(16),
                          height: 1.0,
                          color: AppColors.text.withValues(alpha: 0.5),
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      Text(
                        title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(24),
                          height: 1.0,
                          letterSpacing: 0,
                          color: titleColor ?? AppColors.white,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(18),
                          height: 1.0,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t12)),
                      PrimaryButton(
                        label: confirmLabel,
                        onPressed: onConfirm,
                        color: confirmColor,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _DialogSecondaryButton(
                        label: cancelLabel,
                        onPressed: onCancel,
                        color: cancelColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Always outlined — never reuse a filled [PrimaryButton] for dialog cancel.
class _DialogSecondaryButton extends StatelessWidget {
  const _DialogSecondaryButton({
    required this.label,
    required this.onPressed,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.accent;
    return SizedBox(
      width: double.infinity,
      height: context.dw(50),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: accent,
          side: BorderSide(color: accent),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
          ),
          textStyle: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w600,
            fontSize: context.dw(24),
            height: 1.2,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
