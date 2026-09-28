import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';
import '../styles/typography.dart';

/// Top flash messages, GetX-style (no BuildContext needed).
///
/// Dark surface + semantic accent bar — matches cards / confirm dialogs,
/// not Material filled snackbars.
///
/// Usage: `AppFlash.success('saved'.tr);`
///
/// If you also [Get.back], call the flash **after** popping (or use
/// [successAndBack]) — otherwise the snackbar is dismissed with the route.
class AppFlash {
  AppFlash._();

  static void info(String message, {String? title, Duration? duration}) =>
      _show(
        title: title,
        message: message,
        accent: AppColors.accent,
        icon: Icons.info_outline_rounded,
        duration: duration,
      );

  static void success(String message, {String? title, Duration? duration}) =>
      _show(
        title: title,
        message: message,
        accent: AppColors.success,
        icon: Icons.check_circle_outline_rounded,
        duration: duration,
      );

  static void error(String message, {String? title, Duration? duration}) =>
      _show(
        title: title,
        message: message,
        accent: AppColors.error,
        icon: Icons.error_outline_rounded,
        duration: duration,
      );

  /// Pops the current route, then shows a success flash on the screen
  /// underneath (so [Get.back] does not wipe the snackbar).
  static void successAndBack(String message) {
    Get.back();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      success(message);
    });
  }

  static void _show({
    required String message,
    required Color accent,
    required IconData icon,
    String? title,
    Duration? duration,
  }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.rawSnackbar(
      messageText: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: accent, size: 22),
          const SizedBox(width: AppSpacing.t12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: AppTypography.fieldLabel.copyWith(
                      color: AppColors.subtext,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.t02),
                ],
                Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.text,
                    height: 1.0,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: AppColors.surfaceRaised,
      borderColor: AppColors.surfaceCard,
      borderWidth: 1,
      borderRadius: AppSpacing.radiusMd,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.t16,
        AppSpacing.t12,
        AppSpacing.t16,
        AppSpacing.t12,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.t16,
        vertical: AppSpacing.t14,
      ),
      leftBarIndicatorColor: accent,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.45),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      duration: duration ?? 3.seconds,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
