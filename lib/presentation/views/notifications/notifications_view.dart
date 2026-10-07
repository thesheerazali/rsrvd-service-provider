import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/notifications/notifications_controller.dart';
import '../../widgets/app_back_title_header.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_figma_switch.dart';

/// Settings → Notifications — Elite content.
class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

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
                title: 'settings_notifications'.tr,
                onBack: controller.goBack,
              ),
              Expanded(
                child: Obx(() {
                  final p = controller.prefs.value;
                  return ListView(
                    padding: EdgeInsets.fromLTRB(
                      context.dw(AppSpacing.t30),
                      context.dw(AppSpacing.t20),
                      context.dw(AppSpacing.t30),
                      context.dw(AppSpacing.t40),
                    ),
                    children: [
                      _ToggleCard(
                        label: 'notif_new_member_messages'.tr,
                        value: p.newMemberMessages,
                        onChanged: controller.setNewMemberMessages,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_contract_activity'.tr,
                        value: p.contractActivity,
                        onChanged: controller.setContractActivity,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_payments_releases'.tr,
                        value: p.paymentsAndReleases,
                        onChanged: controller.setPaymentsAndReleases,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_project_status'.tr,
                        value: p.projectStatusUpdates,
                        onChanged: controller.setProjectStatusUpdates,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_membership_renewals'.tr,
                        value: p.membershipAndRenewals,
                        onChanged: controller.setMembershipAndRenewals,
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Figma row: `#181818` card, 20px pad, 8px radius, `#242424` 0.5 stroke.
class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
          border: Border.all(color: AppColors.surfaceCard, width: 0.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: context.dw(20),
                  height: 32 / 20,
                  color: AppColors.white,
                ),
              ),
            ),
            AppFigmaSwitch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
