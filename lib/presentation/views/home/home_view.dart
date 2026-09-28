import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/home/home_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/auth_chrome.dart';
import '../../widgets/primary_button.dart';

/// Minimal post-auth stub until provider home / shell lands.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t30)),
            child: Column(
              children: [
                SizedBox(height: context.dw(AppSpacing.t40)),
                const BrandLogoHeader(),
                const Spacer(),
                Text(
                  'home_greeting'.trParams({
                    'name': controller.displayName,
                  }),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(28),
                    height: 1.2,
                    color: AppColors.white,
                  ),
                ),
                if (controller.providerId.isNotEmpty) ...[
                  SizedBox(height: context.dw(AppSpacing.t10)),
                  Text(
                    controller.providerId,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(18),
                      color: AppColors.subtext,
                    ),
                  ),
                ],
                SizedBox(height: context.dw(AppSpacing.t20)),
                Text(
                  'home_stub_body'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w400,
                    fontSize: context.dw(20),
                    height: 1.2,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                PrimaryButton(
                  label: 'sign_out'.tr,
                  outlined: true,
                  onPressed: controller.signOut,
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
