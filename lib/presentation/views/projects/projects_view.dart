import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/projects/projects_controller.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_partner_project_card.dart';

/// Partners Projects tab — Figma `1196:4039` (empty) / `1196:4121` (list).
class ProjectsView extends GetView<ProjectsController> {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _ProjectsTopBar(),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.projects.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (controller.showEmpty) {
              return const _EmptyLayout();
            }
            return const _ProjectsListLayout();
          }),
        ),
      ],
    );
  }
}

class _EmptyLayout extends GetView<ProjectsController> {
  const _EmptyLayout();

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
          SizedBox(height: context.dw(AppSpacing.t30)),
          Obx(() {
            final stages = controller.stageTabs.toList();
            final stageIndex = controller.selectedStageIndex.value;
            if (stages.isEmpty) return const SizedBox.shrink();
            return _StageTabs(
              tabs: stages,
              selectedIndex: stageIndex,
              onSelected: controller.selectStage,
            );
          }),
          Expanded(
            child: Center(
              child: AppEmptyState(
                imageAsset: AppImages.emptyProject,
                title: 'empty_projects_title'.tr,
                body: 'empty_projects_body'.tr,
                ctaLabel: 'empty_projects_cta'.tr,
                onCtaPressed: controller.onViewMessages,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectsListLayout extends GetView<ProjectsController> {
  const _ProjectsListLayout();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.filteredProjects;
      final placeholder = controller.searchPlaceholder.value;
      final stages = controller.stageTabs.toList();
      final stageIndex = controller.selectedStageIndex.value;
      controller.query.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.dw(AppSpacing.t30),
              context.dw(AppSpacing.t20),
              context.dw(AppSpacing.t30),
              0,
            ),
            child: const _SectionHeader(),
          ),
          SizedBox(height: context.dw(AppSpacing.t20)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.dw(AppSpacing.t30),
            ),
            child: _StageTabs(
              tabs: stages,
              selectedIndex: stageIndex,
              onSelected: controller.selectStage,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                context.dw(AppSpacing.t30),
                context.dw(AppSpacing.t20),
                context.dw(AppSpacing.t30),
                context.dw(AppSpacing.t30),
              ),
              children: [
                _SearchRow(placeholder: placeholder),
                SizedBox(height: context.dw(AppSpacing.t20)),
                for (var i = 0; i < items.length; i++) ...[
                  AppPartnerProjectCard(
                    item: items[i],
                    onTap: () => controller.openProject(items[i]),
                  ),
                  if (i != items.length - 1)
                    SizedBox(height: context.dw(AppSpacing.t10)),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _ProjectsTopBar extends GetView<ProjectsController> {
  const _ProjectsTopBar();

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
              'tab_projects'.tr,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w600,
                fontSize: context.dw(24),
                height: 1.2,
                color: AppColors.text.withValues(alpha: 0.8),
              ),
            ),
          ),
          if (controller.showDebugToggle) const _DebugEmptyToggle(),
        ],
      ),
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
          'projects_title'.tr,
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w700,
            fontSize: context.dw(32),
            height: 1.0,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t10)),
        Text(
          'projects_subtitle'.tr,
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

class _StageTabs extends StatelessWidget {
  const _StageTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dw(53),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(i),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == selectedIndex
                            ? AppColors.primary
                            : AppColors.surfaceCard,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    tabs[i],
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(20),
                      height: 1.0,
                      color: i == selectedIndex
                          ? AppColors.primary
                          : AppColors.text.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchRow extends GetView<ProjectsController> {
  const _SearchRow({required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: context.dw(50),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
              border: Border.all(color: AppColors.surfaceCard),
            ),
            padding:
                EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t16)),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.iconSearch,
                  width: context.dw(24),
                  height: context.dw(24),
                ),
                SizedBox(width: context.dw(AppSpacing.t12)),
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: context.dw(20),
                      height: 1.0,
                      color: AppColors.text,
                    ),
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: placeholder,
                      hintStyle: GoogleFonts.darkerGrotesque(
                        fontWeight: FontWeight.w400,
                        fontSize: context.dw(20),
                        height: 1.0,
                        color: AppColors.text.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: context.dw(AppSpacing.t10)),
        GestureDetector(
          onTap: controller.openFilters,
          child: SvgPicture.asset(
            AppIcons.iconMessageFilter,
            width: context.dw(53),
            height: context.dw(50),
          ),
        ),
      ],
    );
  }
}

class _DebugEmptyToggle extends GetView<ProjectsController> {
  const _DebugEmptyToggle();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final on = controller.debugShowEmpty.value;
      return GestureDetector(
        onTap: controller.toggleDebugEmpty,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.dw(AppSpacing.t12),
            vertical: context.dw(6),
          ),
          decoration: BoxDecoration(
            color: on
                ? AppColors.accent.withValues(alpha: 0.2)
                : AppColors.surfaceCard,
            borderRadius:
                BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
            border: Border.all(
              color: on ? AppColors.accent : AppColors.surfaceCard,
            ),
          ),
          child: Text(
            on ? 'List' : 'Empty',
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w600,
              fontSize: context.dw(14),
              height: 1.0,
              color: on ? AppColors.accent : AppColors.muted,
            ),
          ),
        ),
      );
    });
  }
}
