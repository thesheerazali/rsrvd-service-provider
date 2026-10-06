import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/signed_nda/signed_nda_controller.dart';
import '../../widgets/app_back_title_header.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_nda_card.dart';

/// Settings → Signed NDA — onboarding NDA body + expanded signature details.
class SignedNdaView extends GetView<SignedNdaController> {
  const SignedNdaView({super.key});

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
                title: 'settings_signed_nda'.tr,
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
                    const AppNdaBodyCard(),
                    SizedBox(height: context.dw(AppSpacing.t24)),
                    AppNdaSignatureDetails(
                      signedBy: controller.signedBy,
                      date: controller.dateLabel,
                      time: controller.timeLabel,
                      version: controller.versionLabel,
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

