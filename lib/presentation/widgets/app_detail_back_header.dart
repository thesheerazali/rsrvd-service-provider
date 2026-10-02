import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import '../../core/styles/app_spacing.dart';

/// Back-only header strip — aligned with Elite.
class AppDetailBackHeader extends StatelessWidget {
  const AppDetailBackHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceCard, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t10),
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t16),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: onBack,
          child: SvgPicture.asset(
            AppIcons.iconArrowLeft,
            width: context.dw(24),
            height: context.dw(24),
          ),
        ),
      ),
    );
  }
}
