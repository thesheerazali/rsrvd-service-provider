import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsrvd_service_provider/presentation/widgets/gold_divider.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/models/partner_contract.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/create_contract/create_contract_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_detail_back_header.dart';
import '../../widgets/app_rich_card.dart';
import '../../widgets/primary_button.dart';

/// Contract preview before send — Figma; same [AppRichCard] Elite renders in chat.
class ContractPreviewView extends GetView<CreateContractController> {
  const ContractPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final draft = args is PartnerContract ? args : controller.buildDraft();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(
          child: Column(
            children: [
              AppDetailBackHeader(onBack: controller.goBack),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t20),
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        controller.memberName,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(20),
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      Text(
                        'contract_preview_title'.tr,
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.w600,
                          fontSize: context.dw(24),
                          height: 1.0,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      AppRichCard(card: draft.toRichCard()),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      GoldDivider(),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      Obx(() {
                        final busy = controller.isSending.value;
                        return PrimaryButton(
                          label: 'contract_send_cta'.tr,
                          enabled: !busy,
                          onPressed: () => controller.sendContract(draft),
                        );
                      }),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      Center(
                        child: GestureDetector(
                          onTap: controller.goBack,
                          child: Text(
                            'contract_edit_cta'.tr,
                            style: GoogleFonts.darkerGrotesque(
                              fontWeight: FontWeight.w600,
                              fontSize: context.dw(24),
                              height: 1.2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
