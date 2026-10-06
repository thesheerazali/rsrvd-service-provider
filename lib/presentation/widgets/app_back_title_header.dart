import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import '../../core/styles/app_spacing.dart';

/// Back arrow + screen title strip (Settings sub-screens, profile, etc.).
class AppBackTitleHeader extends StatelessWidget {
  const AppBackTitleHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.titleWeight = FontWeight.w500,
    this.expandTitle = true,
    this.trailing,
  });

  final String title;
  final VoidCallback onBack;
  final FontWeight titleWeight;

  /// When true, title uses [Expanded] (long titles truncate with ellipsis).
  final bool expandTitle;

  /// Optional widget after the title row (e.g. debug actions).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final iconSize = context.dw(24);
    final titleStyle = GoogleFonts.darkerGrotesque(
      fontWeight: titleWeight,
      fontSize: iconSize,
      height: 1.0,
      color: AppColors.white
    );

    final titleWidget = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: titleStyle,
    );

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
      child: Row(
     mainAxisAlignment: MainAxisAlignment.start,
     crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: 
            SvgPicture.asset(
                  AppIcons.iconArrowLeft,
                
                ),
            
          ),
          SizedBox(width: context.dw(AppSpacing.t12)),
          if (expandTitle) Expanded(child: titleWidget) else titleWidget,
          ?trailing,
        ],
      ),
    );
  }
}
