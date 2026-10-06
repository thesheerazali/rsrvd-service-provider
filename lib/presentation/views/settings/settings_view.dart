import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/settings/settings_controller.dart';
import '../../widgets/app_back_title_header.dart';
import '../../widgets/app_background.dart';

/// Profile → Settings — Figma `1196:3205`.
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

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
                title: 'settings_title'.tr,
                onBack: controller.goBack,
                titleWeight: FontWeight.w600,
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
                    _SettingsGroup(
                      rows: [
                        _SettingsRowData(
                          icon: AppIcons.iconEditProfileSettings,
                          label: 'settings_edit_profile'.tr,
                          onTap: controller.openEditProfile,
                          
                        ),
                        _SettingsRowData(
                          icon: AppIcons.iconNotificationSettings,
                          label: 'settings_notifications'.tr,
                          onTap: controller.openNotifications,
                        ),
                      ],
                    ),
                    SizedBox(height: context.dw(AppSpacing.t30)),
                    _SettingsGroup(
                      rows: [
                        _SettingsRowData(
                          icon: AppIcons.iconMembership,
                          label: 'settings_membership'.tr,
                          onTap: controller.openMembership,
                        ),
                        _SettingsRowData(
                          icon: AppIcons.iconReviews,
                          label: 'settings_reviews'.tr,
                          onTap: controller.openReviews,
                        ),
                        _SettingsRowData(
                          icon: AppIcons.iconNda,
                          label: 'settings_signed_nda'.tr,
                          onTap: controller.openSignedNda,
                        ),
                        _SettingsRowData(
                          icon: AppIcons.iconDocuments,
                          label: 'settings_documents'.tr,
                          onTap: controller.openDocuments,
                        ),
                      ],
                    ),
                    SizedBox(height: context.dw(AppSpacing.t30)),
                    _SettingsGroup(
                      rows: [
                        _SettingsRowData(
                          icon: AppIcons.iconHelp,
                          label: 'settings_help'.tr,
                          onTap: controller.openHelp,
                        ),
                        _SettingsRowData(
                          icon: AppIcons.iconPartnerTerms,
                          label: 'settings_partner_terms'.tr,
                          onTap: controller.openPartnerTerms,
                        ),
                        _SettingsRowData(
                          icon: AppIcons.iconPrivacy,
                          label: 'settings_privacy'.tr,
                          onTap: controller.openPrivacy,
                        ),
                      ],
                    ),
                    SizedBox(height: context.dw(AppSpacing.t30)),
                    _SettingsGroup(
                      showChevron: false,
                      rows: [
                        _SettingsRowData(
                          icon: AppIcons.iconChangePassword,
                          label: 'settings_change_password'.tr,
                          onTap: controller.openChangePassword,
                        ),
                        _SettingsRowData(
                          icon: AppIcons.iconLogout,
                          label: 'settings_logout'.tr,
                          onTap: controller.logout,
                        ),
                        _SettingsRowData(
                          icon: AppIcons.iconDeleteAccount,
                          label: 'settings_delete_account'.tr,
                          labelColor: AppColors.errorAlt,
                          onTap: controller.deleteAccount,
                        ),
                      ],
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

class _SettingsRowData {
  const _SettingsRowData({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({
    required this.rows,
    this.showChevron = true,
  });

  final List<_SettingsRowData> rows;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: context.dw(8),
            offset: Offset(0, context.dw(2)),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _SettingsRow(data: rows[i], showChevron: showChevron),
            if (i != rows.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.surfaceCard,
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.data,
    required this.showChevron,
  });

  final _SettingsRowData data;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final labelColor = data.labelColor ?? AppColors.text;
    final isError = data.labelColor != null;

    return GestureDetector(
      onTap: data.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: context.dw(53),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t20)),
          child: Row(
            children: [
              SvgPicture.asset(
                data.icon,
                width: context.dw(20),
                height: context.dw(20),
                colorFilter: isError
                    ? ColorFilter.mode(labelColor, BlendMode.srcIn)
                    : null,
              ),
              SizedBox(width: context.dw(AppSpacing.t10)),
              Expanded(
                child: Text(
                  data.label,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: isError ? FontWeight.w500 : FontWeight.w400,
                    fontSize: context.dw(20),
                    height: 1.2,
                    color: labelColor,
                  ),
                ),
              ),
              if (showChevron)
                SvgPicture.asset(
                  AppIcons.iconChevronRight,
                  width: context.dw(15),
                  height: context.dw(15),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
