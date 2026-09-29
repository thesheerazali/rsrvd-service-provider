import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Multi-select pill chips — Figma Partner Application service categories
/// (selected: primary fill + white; unselected: primary @ 10% + primary text).
class AppSelectChipWrap extends StatelessWidget {
  const AppSelectChipWrap({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelected,
  });

  final List<({String id, String label})> items;
  final Set<String> selectedIds;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: context.dw(AppSpacing.t10),
        runSpacing: context.dw(AppSpacing.t10),
        children: [
          for (final item in items)
            GestureDetector(
              onTap: () => onSelected(item.id),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: selectedIds.contains(item.id)
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    context.dw(AppSpacing.radiusPill),
                  ),
                  border: selectedIds.contains(item.id)
                      ? Border.all(color: AppColors.primary, width: 0.5)
                      : null,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dw(AppSpacing.t20),
                    vertical: context.dw(6.5),
                  ),
                  child: Text(
                    item.label,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: selectedIds.contains(item.id)
                          ? FontWeight.w600
                          : FontWeight.w400,
                      fontSize: context.dw(20),
                      height: 1.0,
                      color: selectedIds.contains(item.id)
                          ? AppColors.white
                          : AppColors.primary
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
