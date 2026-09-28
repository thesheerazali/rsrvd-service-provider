import 'package:flutter/material.dart';

import '../../core/styles/app_images.dart';
import '../../core/styles/design_scale.dart';

/// Glow placement variants from Figma.
enum AppGlowStyle {
  hero, // Splash / Welcome — full top gold wash.
  auth, // Auth screens — same glow as splash, shifted up (~30% visible).
  home, // Home screen — same glow as splash, shifted up (~30% visible).
}

/// Soft top gold wash (`glow_top.png` from Figma Group 2).
class GoldenTopGlow extends StatelessWidget {
  const GoldenTopGlow({
    super.key,
    this.style = AppGlowStyle.auth,
  });

  final AppGlowStyle style;

  /// Testing bypass — set `false` to show glow again everywhere this widget is used.
  static const bool showGlow = false;

  @override
  Widget build(BuildContext context) {
    if (!showGlow) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = DesignScale.of(context);
        final spec = switch (style) {
          AppGlowStyle.hero => _GlowSpec.hero,
          AppGlowStyle.auth => _GlowSpec.auth,
          AppGlowStyle.home => _GlowSpec.home,
        };

        return Opacity(
          opacity: spec.opacity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: spec.left * scale,
                top: spec.top * scale,
                width: spec.width * scale,
                height: spec.height * scale,
                child: Image.asset(
                  AppImages.glowTop,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlowSpec {
  const _GlowSpec({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.opacity,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final double opacity;

  /// Splash / Welcome — full wash.
  static const hero = _GlowSpec(
    left: -186,
    top: -289,
    width: 811.24,
    height: 646.12,
    opacity: 0.8,
  );

  /// Auth — same asset/size as [hero], nudged up so ~30% shows.
  static const auth = _GlowSpec(
    left: -120,
    top: -450,
    width: 811.24,
    height: 646.12,
    opacity: 0.8,
  );

    static const home = _GlowSpec(
    left: -200,
    top: -330,
    width: 707.24,
    height: 454.12,
    opacity: 0.5,
  );
}
