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

/// Settings → Notifications — same Elite layout; Partner labels.
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
                        label: 'notif_service_updates'.tr,
                        value: p.serviceUpdates,
                        onChanged: controller.setServiceUpdates,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_new_opportunities'.tr,
                        value: p.newOpportunities,
                        onChanged: controller.setNewOpportunities,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_member_requests'.tr,
                        value: p.memberRequests,
                        onChanged: controller.setMemberRequests,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_message_updates'.tr,
                        value: p.messageUpdates,
                        onChanged: controller.setMessageUpdates,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_project_updates'.tr,
                        value: p.projectUpdates,
                        onChanged: controller.setProjectUpdates,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_review_ratings'.tr,
                        value: p.reviewRatings,
                        onChanged: controller.setReviewRatings,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_membership_updates'.tr,
                        value: p.membershipUpdates,
                        onChanged: controller.setMembershipUpdates,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      _ToggleCard(
                        label: 'notif_account_security'.tr,
                        value: p.accountSecurity,
                        onChanged: controller.setAccountSecurity,
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
