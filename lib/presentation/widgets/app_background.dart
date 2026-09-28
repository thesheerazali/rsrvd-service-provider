import 'package:flutter/material.dart';

import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import 'blend_mask.dart';
import 'golden_top_glow.dart';

export 'golden_top_glow.dart' show AppGlowStyle;

/// App-wide screen background — same Figma stack as Elite.
///
/// 1. Ink `#111111`
/// 2. Soft top gold glow (`glow_top.png`)
/// 3. Constellation — Color Dodge · 50% · cover + 20% zoom
/// 4. [child]
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.showGlow = true,
    this.glowStyle = AppGlowStyle.auth,
  });

  final Widget child;
  final bool showGlow;
  final AppGlowStyle glowStyle;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          if (showGlow)
            Positioned.fill(
              child: IgnorePointer(
                child: GoldenTopGlow(style: glowStyle),
              ),
            ),
          const Positioned.fill(
            child: IgnorePointer(child: _ConstellationLayer()),
          ),
          child,
        ],
      ),
    );
  }
}

class _ConstellationLayer extends StatelessWidget {
  const _ConstellationLayer();

  static const double _zoom = 1.2;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth * _zoom;
        final h = constraints.maxHeight * _zoom;

        return ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: w,
            maxWidth: w,
            minHeight: h,
            maxHeight: h,
            child: BlendMask(
              blendMode: BlendMode.colorDodge,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  AppImages.background,
                  width: w,
                  height: h,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.none,
                  isAntiAlias: false,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
