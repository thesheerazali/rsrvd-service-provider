import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../widgets/app_background.dart';

/// Placeholder tab until the feature screen lands.
class PlaceholderTabView extends StatelessWidget {
  const PlaceholderTabView({
    super.key,
    required this.titleKey,
  });

  final String titleKey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t30)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titleKey.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(24),
                color: AppColors.white,
              ),
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'coming_soon'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(18),
                color: AppColors.subtext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standalone scaffold wrapper unused inside shell — kept for route stubs.
class PlaceholderTabPage extends StatelessWidget {
  const PlaceholderTabPage({super.key, required this.titleKey});

  final String titleKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(child: PlaceholderTabView(titleKey: titleKey)),
      ),
    );
  }
}
