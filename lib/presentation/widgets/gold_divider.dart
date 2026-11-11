import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/styles/app_images.dart';

/// Home section rule from Figma Home (`1563:26344`).
///
/// 380×3 gold path (`#C9B48F`) at **20%** layer opacity.
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
