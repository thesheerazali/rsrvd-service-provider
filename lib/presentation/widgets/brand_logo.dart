import 'package:flutter/material.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_images.dart';

/// Small header logo — Figma ~100×36 (same asset as Elite).
class BrandLogoHeader extends StatelessWidget {
  const BrandLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logoHeader,
      width: context.dw(100),
      height: context.dw(36),
      fit: BoxFit.contain,
    );
  }
}

/// Large splash logo — Figma ~264×119 (same asset as Elite).
class BrandLogoSplash extends StatelessWidget {
  const BrandLogoSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logoSplash,
      width: context.dw(264),
      height: context.dw(119),
      fit: BoxFit.contain,
    );
  }
}
