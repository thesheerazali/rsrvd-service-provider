import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/models/partner_service.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/service_review_status/service_review_status_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_detail_back_header.dart';
import '../../widgets/app_notice_banner.dart';
import '../../widgets/gold_divider.dart';
import '../../widgets/primary_button.dart';

/// Service review gate — Approved / Not Approved.
/// Typography mirrors [ApplicationStatusView] (eyebrow DG 18, title Cinzel 24, body DG 20).
class ServiceReviewStatusView extends GetView<ServiceReviewStatusController> {
  const ServiceReviewStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.auth,
        child: SafeArea(
          child: Column(
            children: [
              AppDetailBackHeader(onBack: controller.goBack),
              Expanded(
                child: Obx(() {
                  final s = controller.status.value;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.dw(AppSpacing.t24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Spacer(),
                              _StatusBody(
                                status: s,
                                rejectionReason: controller.rejectionReason,
                              ),
                              if (s == PartnerServiceReviewStatus.approved) ...[
                                SizedBox(height: context.dw(AppSpacing.t30)),
                                PrimaryButton(
                                  label: 'service_status_continue_home'.tr,
                                  onPressed: controller.continueToHome,
                                ),
                              ],
                              if (s == PartnerServiceReviewStatus.rejected) ...[
                                SizedBox(height: context.dw(AppSpacing.t30)),
                                PrimaryButton(
                                  label: 'service_status_resubmit'.tr,
                                  onPressed: controller.resubmit,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBody extends StatelessWidget {
  const _StatusBody({
    required this.status,
    required this.rejectionReason,
  });

  final PartnerServiceReviewStatus status;
  final String rejectionReason;

  @override
  Widget build(BuildContext context) {
    final eyebrowStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(18),
      height: 1,
      color: AppColors.text,
    );
    final titleStyle = GoogleFonts.cinzel(
      fontWeight: FontWeight.w700,
      fontSize: context.dw(24),
      height: 1.2,
      color: AppColors.text,
    );
    final bodyStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w600,
      fontSize: context.dw(20),
      letterSpacing: 0,
      height: 1.0,
      color: AppColors.text,
    );

    return switch (status) {
      PartnerServiceReviewStatus.pending => Column(
          children: [
            Text(
              'service_status_pending_eyebrow'.tr,
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'service_status_pending_title'.tr.toUpperCase(),
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'service_status_pending_body'.tr,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t30)),
            AppNoticeBanner(
              message: 'service_status_pending_notice'.tr,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      PartnerServiceReviewStatus.approved => Column(
          children: [
            Text(
              'service_status_approved_eyebrow'.tr,
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'service_status_approved_title'.tr.toUpperCase(),
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'service_status_approved_body'.tr,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t30)),
            const GoldDivider(),
          ],
        ),
      PartnerServiceReviewStatus.rejected => Column(
          children: [
            Text(
              'service_status_rejected_eyebrow'.tr,
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'service_status_rejected_title'.tr.toUpperCase(),
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t10)),
            Text(
              'service_status_rejected_body'.tr,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
            SizedBox(height: context.dw(AppSpacing.t30)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t20), vertical: context.dw(AppSpacing.t10)),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius:
                    BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
                border: Border.all(color: AppColors.surfaceCard),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'service_status_reason_label'.tr,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w700,
                      fontSize: context.dw(16),
                      height: 1.2,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: context.dw(AppSpacing.t10)),
                  Text(
                    rejectionReason,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(16),
                      height: 1.25,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.dw(AppSpacing.t30)),
            const GoldDivider(),
          ],
        ),
    };
  }
}

class _DebugStatusToggles extends StatelessWidget {
  const _DebugStatusToggles({
    required this.current,
    required this.onSelect,
  });

  final PartnerServiceReviewStatus current;
  final ValueChanged<PartnerServiceReviewStatus> onSelect;

  static const _options = <(PartnerServiceReviewStatus, String)>[
    (PartnerServiceReviewStatus.pending, 'Pending'),
    (PartnerServiceReviewStatus.approved, 'Approved'),
    (PartnerServiceReviewStatus.rejected, 'Rejected'),
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
              GestureDetector(
                onTap: () => onSelect(value),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dw(AppSpacing.t12),
                    vertical: context.dw(AppSpacing.t06),
                  ),
                  decoration: BoxDecoration(
                    color: current == value
                        ? AppNoticeBanner.fill
                        : AppColors.surfaceCard.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(
                      context.dw(AppSpacing.radiusPill),
                    ),
                    border: Border.all(
                      color: current == value
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : AppColors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(12),
                      color: current == value
                          ? AppColors.primary
                          : AppColors.muted,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
