import 'package:flutter/material.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';

/// Custom toggle — Figma `45×23`, track primary@5% + primary 0.5 stroke,
/// thumb `15×15` primary. Off state = whole control @ 30% opacity (thumb left).
class AppFigmaSwitch extends StatelessWidget {
  const AppFigmaSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final trackW = context.dw(45);
    final trackH = context.dw(23);
    final thumb = context.dw(15);
    final inset = context.dw(4);

    return Opacity(
      opacity: value ? 1.0 : 0.3,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: trackW,
          height: trackH,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(context.dw(40)),
            border: Border.all(color: AppColors.primary, width: 0.5),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                left: value ? trackW - thumb - inset : inset,
                top: inset,
                child: Container(
                  width: thumb,
                  height: thumb,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
