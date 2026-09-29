import 'package:flutter/material.dart';

import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import 'blend_mask.dart';
import 'golden_top_glow.dart';

export 'golden_top_glow.dart' show AppGlowStyle;
/// App-wide screen background from Figma Splash / auth.
///
/// Layer order matches Figma:
/// 1. Ink `#111111`
/// 2. Soft top gold glow (`glow_top.png`)
/// 3. Constellation photo with **Color Dodge**
/// 4. [child]
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.showGlow = true,
    this.glowStyle = AppGlowStyle.auth,
  });

  final Widget child;

  /// Top gold nebula.
  final bool showGlow;

  /// [AppGlowStyle.hero] for Splash/Welcome; [AppGlowStyle.auth] elsewhere.
  final AppGlowStyle glowStyle;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
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

/// `bg_constellations.png` — Figma blend mode Color Dodge.
class _ConstellationLayer extends StatelessWidget {
  const _ConstellationLayer();

  @override
  Widget build(BuildContext context) {
    return BlendMask(
      blendMode: BlendMode.colorDodge,
      child: Image.asset(
        AppImages.background,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
