import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/privacy_policy/privacy_policy_controller.dart';
import '../../widgets/app_back_title_header.dart';
import '../../widgets/app_background.dart';

/// Settings → Privacy Policy — same Elite layout; Partner copy.
class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppBackTitleHeader(
                title: 'settings_privacy'.tr,
                onBack: controller.goBack,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t20),
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t40),
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          context.dw(AppSpacing.radiusSm),
                        ),
                        border: Border.all(
                          color: AppColors.surfaceCard,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        PrivacyPolicyController.body,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w600,
                          fontSize: context.dw(20),
                          height: 1.2,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

