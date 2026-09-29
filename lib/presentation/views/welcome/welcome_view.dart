import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/welcome/welcome_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/primary_button.dart';

/// Partners onboarding — Figma lower-half stack: title, body, sparks, CTA.
class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  static const _bullets = [
    'welcome_bullet_1',
    'welcome_bullet_2',
    'welcome_bullet_3',
  ];

  @override
  Widget build(BuildContext context) {
    final bodyStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(20),
      height: 1,
      color: AppColors.white,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.hero,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.dw(AppSpacing.t30),
              0,
              context.dw(AppSpacing.t30),
              context.dw(AppSpacing.t40),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Text(
                  'welcome_title'.tr.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    fontSize: context.dw(32),
                    height: 1.2,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t10)),
                Text(
                  'welcome_body'.tr,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w400,
      fontSize: context.dw(24),
      height: 1,
      color: Colors.white,
    ),
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                for (var i = 0; i < _bullets.length; i++) ...[
                  if (i > 0) SizedBox(height: context.dw(AppSpacing.t10)),
                  _WelcomeBullet(
                    text: _bullets[i].tr,
                    style: bodyStyle,
                  ),
                ],
                SizedBox(height: context.dw(AppSpacing.t30)),
                PrimaryButton(
                  label: 'welcome_cta'.tr,
                  onPressed: controller.getStarted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeBullet extends StatelessWidget {
  const _WelcomeBullet({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: context.dw(3)),
          child: SvgPicture.asset(
            AppIcons.aiMagic,
            width: context.dw(18),
            height: context.dw(15),
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        SizedBox(width: context.dw(AppSpacing.t10)),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }
}
