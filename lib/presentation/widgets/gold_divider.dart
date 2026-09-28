import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/styles/app_images.dart';

/// Home section rule from Figma (`1001:486`).
///
/// 380×3 diamond path, opacity 0.2, linear `#FFE898` → `#8D5B1A`.
class GoldDivider extends StatelessWidget {
  const GoldDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppIcons.goldDivider,
      width: double.infinity,
      height: 3,
      fit: BoxFit.fill,
    );
  }
}
