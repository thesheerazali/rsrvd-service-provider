import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Soft green status pill — e.g. `Open` / `Limited Availability`.
class AppStatusPill extends StatelessWidget {
  const AppStatusPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dw(15),
        vertical: context.dw(3),
      ),
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.dw(3),
            height: context.dw(3),
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: context.dw(3)),
          Text(
            label,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(14),
              height: 1.0,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
