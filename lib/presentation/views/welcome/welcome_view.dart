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

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.hero,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t30)),
            child: Column(
              children: [
                const Spacer(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.aiMagic,
                          width: context.dw(21),
                          height: context.dw(21),
                        ),
                        SizedBox(width: context.dw(AppSpacing.t05)),
                        Text(
                          'welcome_eyebrow'.tr,
                          style: GoogleFonts.darkerGrotesque(
                            fontWeight: FontWeight.w500,
                            fontSize: context.dw(22),
                            height: 1.2,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.dw(AppSpacing.t30)),
                    Text(
                      'welcome_title'.tr.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cinzel(
                        fontWeight: FontWeight.w500,
                        fontSize: context.dw(32),
                        height: 1.2,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: context.dw(AppSpacing.t10)),
                    Text(
                      'welcome_body'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.darkerGrotesque(
                        fontWeight: FontWeight.w400,
                        fontSize: context.dw(24),
                        height: 1.0,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: context.dw(AppSpacing.t30)),
                    PrimaryButton(
                      label: 'get_started'.tr,
                      onPressed: controller.getStarted,
                    ),
                  ],
                ),
                SizedBox(height: context.dw(AppSpacing.t40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
