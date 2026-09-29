import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Removable pill chip — Figma Partner Application expertise / service areas
/// (`1196:284` · padding `3×15` · close `21` · fill primary @ 10%).
///
/// Hugs label width — do **not** set [Container.alignment] (that expands full width).
class AppRemovableChip extends StatelessWidget {
  const AppRemovableChip({
    super.key,
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final closeSize = context.dw(21);
    final edgePad = context.dw(AppSpacing.t08);

    return Padding(
      padding: EdgeInsets.only(top: edgePad, right: edgePad),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.dw(AppSpacing.t15),
                vertical: context.dw(AppSpacing.t05),
              ),
              child: Text(
                label,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: context.dw(20),
                  height: 1.2,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Positioned(
            top: -edgePad,
            right: -edgePad,
            child: GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: closeSize,
                height: closeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.primary, width: 0.5),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.close,
                  size: context.dw(12),
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Wrap of [AppRemovableChip] — Figma gap `8`. Chips hug content.
class AppRemovableChipWrap extends StatelessWidget {
  const AppRemovableChipWrap({
    super.key,
    required this.values,
    required this.onRemove,
  });

  final List<String> values;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: context.dw(AppSpacing.t08),
      runSpacing: context.dw(AppSpacing.t08),
      children: [
        for (final value in values)
          AppRemovableChip(
            label: value,
            onRemove: () => onRemove(value),
          ),
      ],
    );
  }
}
