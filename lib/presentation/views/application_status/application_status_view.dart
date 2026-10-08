import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsrvd_service_provider/presentation/widgets/gold_divider.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/models/partner_application_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/application_status/application_status_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_notice_banner.dart';
import '../../widgets/primary_button.dart';

/// Application gate — Submitted / Approved / Rejected.
///
/// Typography mirrors Elite Welcome / ID verification:
/// eyebrow DG 22, title Cinzel 32, body DG 24.
/// Notice banner matches Partner Review ([AppNoticeBanner]).
class ApplicationStatusView extends GetView<ApplicationStatusController> {
  const ApplicationStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.auth,
        child: SafeArea(
          child: Obx(() {
            final s = controller.status.value;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.dw(AppSpacing.t24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: controller.logout,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.white.withValues(alpha: 0.7),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.symmetric(
                          vertical: context.dw(AppSpacing.t08),
                        ),
                      ),
                      child: Text(
                        'sign_out'.tr,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(18),
                          color: AppColors.primary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Spacer(),
                       _StatusBody(status: s),
                        if (s == PartnerApplicationStatus.approved) ...[
                          SizedBox(height: context.dw(AppSpacing.t30)),
                          PrimaryButton(
                            label: 'app_status_continue_membership'.tr,
                            onPressed: controller.continueToMembership,
                          ),
                        ],
                        if (s == PartnerApplicationStatus.rejected) ...[
                          SizedBox(height: context.dw(AppSpacing.t30)),
                          PrimaryButton(
                            label: 'app_status_resubmit'.tr,
                            onPressed: controller.resubmitApplication,
                          ),
                        ],
                        const Spacer(),
                        if (controller.showDebugToggles) ...[
                          _DebugStatusToggles(
                            current: s,
                            onSelect: controller.debugSetStatus,
                          ),
                          SizedBox(height: context.dw(AppSpacing.t12)),
                        ],
                        SizedBox(height: context.dw(AppSpacing.t24)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _StatusBody extends StatelessWidget {
  const _StatusBody({required this.status});

  final PartnerApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    // Elite Welcome eyebrow — DG Medium 22.
    final eyebrowStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(18),
      height: 1,
      color: AppColors.text,
    );
    // Elite Welcome / ID title — Cinzel Medium 32.
    final titleStyle = GoogleFonts.cinzel(
      fontWeight: FontWeight.w700,
      fontSize: context.dw(24),
      height: 1.2,
      color: AppColors.text,
    );
    // Elite Welcome / ID body — DG Regular 24 / lh 1.0.
    final bodyStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w600,
      fontSize: context.dw(18),
      letterSpacing: 0,
      height: 1.0,
      color: AppColors.text,
    );

    return switch (status) {
      PartnerApplicationStatus.submitted => Column(
          children: [
            Text(
              'app_status_submitted_eyebrow'.tr,
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'app_status_submitted_body'.tr,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'app_status_submitted_title'.tr,
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t30)),
            AppNoticeBanner(
              message: 'app_status_submitted_notice'.tr,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      PartnerApplicationStatus.approved => Column(
          children: [
            Text(
              'app_status_approved_eyebrow'.tr,
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'app_status_approved_title'.tr.toUpperCase(),
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'app_status_approved_body'.tr,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t30)),
            GoldDivider(),
           
          ],
        ),
      PartnerApplicationStatus.rejected => Column(
          children: [
            Text(
              'app_status_rejected_eyebrow'.tr,
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'app_status_rejected_title'.tr.toUpperCase(),
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'app_status_rejected_body'.tr,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
                   SizedBox(height: context.dw(AppSpacing.t30)),
            GoldDivider(),
          ],
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _DebugStatusToggles extends StatelessWidget {
  const _DebugStatusToggles({
    required this.current,
    required this.onSelect,
  });

  final PartnerApplicationStatus current;
  final ValueChanged<PartnerApplicationStatus> onSelect;

  static const _options = <(PartnerApplicationStatus, String)>[
    (PartnerApplicationStatus.submitted, 'Submitted'),
    (PartnerApplicationStatus.approved, 'Approved'),
    (PartnerApplicationStatus.rejected, 'Rejected'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'UI debug',
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w500,
            fontSize: context.dw(12),
            color: AppColors.muted,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t08)),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: context.dw(AppSpacing.t08),
          runSpacing: context.dw(AppSpacing.t08),
          children: [
            for (final (value, label) in _options)
              _DebugChip(
                label: label,
                selected: current == value,
                onTap: () => onSelect(value),
              ),
          ],
        ),
      ],
    );
  }
}

class _DebugChip extends StatelessWidget {
  const _DebugChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.dw(AppSpacing.t12),
          vertical: context.dw(AppSpacing.t06),
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppNoticeBanner.fill
              : AppColors.surfaceCard.withValues(alpha: 0.6),
          borderRadius:
              BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w500,
            fontSize: context.dw(12),
            color: selected ? AppColors.primary : AppColors.subtext,
          ),
        ),
      ),
    );
  }
}
