import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import '../../core/styles/app_spacing.dart';
import '../../getx/main_shell/main_shell_controller.dart';

/// Partners bottom nav — Figma `1196:1822`.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  static const _items = <({MainTab tab, String icon, String labelKey})>[
    (tab: MainTab.home, icon: AppIcons.navHome, labelKey: 'tab_home'),
    (
      tab: MainTab.services,
      icon: AppIcons.navServices,
      labelKey: 'tab_services',
    ),
    (tab: MainTab.chats, icon: AppIcons.navChats, labelKey: 'tab_chats'),
    (
      tab: MainTab.projects,
      icon: AppIcons.navProjects,
      labelKey: 'tab_projects',
    ),
    (tab: MainTab.profile, icon: AppIcons.navProfile, labelKey: 'tab_profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainShellController>();
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Obx(() {
      final selected = controller.tabIndex.value;
      return Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.surfaceCard, width: 1),
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.t30,
          0,
          AppSpacing.t30,
          bottom > 0 ? bottom : AppSpacing.t10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < _items.length; i++)
              _NavItem(
                iconPath: _items[i].icon,
                label: _items[i].labelKey.tr,
                selected: selected == i,
                onTap: () => controller.selectTab(i),
              ),
          ],
        ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.iconPath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.text;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: selected ? 1 : 0.5,
        child: SizedBox(
          width: 53,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 1.5,
                color: selected ? AppColors.primary : Colors.transparent,
              ),
              const SizedBox(height: AppSpacing.t05),
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(height: AppSpacing.t02),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.0,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
