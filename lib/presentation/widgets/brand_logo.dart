import 'package:flutter/material.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_images.dart';

/// Small header logo — Figma auth header ~100×51 (same asset as Elite).
class BrandLogoHeader extends StatelessWidget {
  const BrandLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logoHeader,
      width: context.dw(100),
      height: context.dw(51),
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

/// Large splash logo — Figma Splash `attachmentlogo` ~389×292.
class BrandLogoSplash extends StatelessWidget {
  const BrandLogoSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logoSplash,
      width: context.dw(389),
      height: context.dw(292),
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
