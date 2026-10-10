import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/services/services_controller.dart';
import '../../widgets/app_service_card.dart';
import '../../widgets/empty_services_block.dart';

/// My Services — Figma `1196:1490`.
class ServicesView extends GetView<ServicesController> {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _ServicesTopBar(),
        Expanded(
          child: Obx(() {
            if (controller.showEmpty) {
              return _EmptyLayout(
                onAdd: controller.onAddService,
                showDebug: controller.showDebugToggle,
              );
            }
            return _ServicesListLayout(
              showDebug: controller.showDebugToggle,
            );
          }),
        ),
      ],
    );
  }
}

/// Title stays top; empty block centered in remaining space.
class _EmptyLayout extends GetView<ServicesController> {
  const _EmptyLayout({
    required this.onAdd,
    required this.showDebug,
  });

  final VoidCallback onAdd;
  final bool showDebug;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t20),
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(),
          Expanded(
            child: Center(
              child: EmptyServicesBlock(onAddPressed: onAdd),
            ),
          ),
          if (showDebug) const _DebugEmptyToggle(),
        ],
      ),
    );
  }
}

class _ServicesListLayout extends GetView<ServicesController> {
  const _ServicesListLayout({required this.showDebug});

  final bool showDebug;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t20),
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t30),
      ),
      child: Obx(() {
        final items = controller.visibleServices;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionHeader(),
            SizedBox(height: context.dw(AppSpacing.t30)),
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) SizedBox(height: context.dw(AppSpacing.t10)),
              AppServiceCard(
                service: items[i],
                onTap: () => controller.openServiceStatus(items[i]),
                onEdit: () => controller.onEditService(items[i]),
                onDelete: () => controller.onDeleteService(items[i]),
                onBoost: () => controller.onBoostService(items[i]),
              ),
            ],
            if (showDebug) ...[
              SizedBox(height: context.dw(AppSpacing.t24)),
              const _DebugEmptyToggle(),
            ],
          ],
        );
      }),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'my_services_title'.tr,
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w700,
            fontSize: context.dw(32),
            height: 1.0,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t10)),
        Text(
          'my_services_subtitle'.tr,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w500,
            fontSize: context.dw(20),
            height: 1.0,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

class _ServicesTopBar extends GetView<ServicesController> {
  const _ServicesTopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceCard, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t10),
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'tab_services'.tr,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w600,
                fontSize: context.dw(24),
                height: 1.2,
                color: AppColors.text.withValues(alpha: 0.8),
              ),
            ),
          ),
          GestureDetector(
            onTap: controller.onAddService,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              AppIcons.iconAddService,
              width: context.dw(37),
              height: context.dw(37),
            ),
          ),
        ],
      ),
    );
  }
}

class _DebugEmptyToggle extends GetView<ServicesController> {
  const _DebugEmptyToggle();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final empty = controller.services.isEmpty;
      return Center(
        child: GestureDetector(
          onTap: controller.toggleDebugEmpty,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.dw(AppSpacing.t12),
              vertical: context.dw(AppSpacing.t06),
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard.withValues(alpha: 0.7),
              borderRadius:
                  BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              empty ? 'Debug: show cards' : 'Debug: empty state',
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(12),
                color: AppColors.muted,
              ),
            ),
          ),
        ),
      );
    });
  }
}
