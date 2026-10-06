import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Horizontal pill filter used on Projects / Alerts / Real Estate / Messages.
///
/// Selected: primary fill + white SemiBold text (Figma Messages chips).
/// Unselected: primary @ 10% fill + primary text.
class AppFilterChipBar extends StatelessWidget {
  const AppFilterChipBar({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelected,
  });

  final List<({String id, String label})> items;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dw(37),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: context.dw(AppSpacing.t10)),
        itemBuilder: (context, index) {
          final item = items[index];
          final selected = item.id == selectedId;
          return GestureDetector(
            onTap: () => onSelected(item.id),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t20)),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
                border: selected
                    ? Border.all(color: AppColors.primary, width: 0.5)
                    : null,
              ),
              child: Text(
                item.label,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: context.dw(20),
                  height: 1.0,
                  color: selected
                      ? AppColors.white
                      : AppColors.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
