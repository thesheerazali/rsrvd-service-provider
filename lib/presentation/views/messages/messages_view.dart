import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/messages/messages_controller.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_message_tile.dart';

/// Messages inbox — Figma `1196:1863`.
class MessagesView extends GetView<MessagesController> {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _MessagesTopBar(),
        Expanded(
          child: Obx(() {
            if (controller.showEmpty) {
              return const _EmptyLayout();
            }
            return const _InboxLayout();
          }),
        ),
      ],
    );
  }
}

/// Search + filter chips stay; no message tiles when empty.
class _EmptyLayout extends GetView<MessagesController> {
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
      //    const _SectionHeader(),
      //    SizedBox(height: context.dw(AppSpacing.t30)),
          const _SearchRow(),
          SizedBox(height: context.dw(AppSpacing.t30)),
         // const _FilterChips(),
          Expanded(
            child: Center(
              child: AppEmptyState(
                imageAsset: AppImages.emptyMessage,
                title: 'empty_messages_title'.tr,
                body: 'empty_messages_body'.tr,
                ctaLabel: 'empty_messages_cta'.tr,
                onCtaPressed: controller.onAddMoreServices,
              ),
            ),
          ),
          if (controller.showDebugToggle) const _DebugEmptyToggle(),
        ],
      ),
    );
  }
}

class _InboxLayout extends GetView<MessagesController> {
  const _InboxLayout();

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
          const _SearchRow(),
          SizedBox(height: context.dw(AppSpacing.t30)),
          const _FilterChips(),
          SizedBox(height: context.dw(AppSpacing.t10)),
          Expanded(
            child: Obx(() {
              final items = controller.visibleThreads;
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final thread = items[index];
                  return AppMessageTile(
                    thread: thread,
                    onTap: () => controller.onThreadTap(thread),
                  );
                },
              );
            }),
          ),
          if (controller.showDebugToggle) const _DebugEmptyToggle(),
        ],
      ),
    );
  }
}

class _MessagesTopBar extends StatelessWidget {
  const _MessagesTopBar();

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
      child: Text(
        'messages_top_title'.tr,
        style: GoogleFonts.darkerGrotesque(
          fontWeight: FontWeight.w600,
          fontSize: context.dw(24),
          height: 1.2,
          color: AppColors.text.withValues(alpha: 0.8),
        ),
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
          'messages_subtitle'.tr,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w500,
            fontSize: context.dw(20),
            height: 1.0,
            color: AppColors.text,
          ),
        ),
          SizedBox(height: context.dw(AppSpacing.t10)),
           Text(
          'messages_title'.tr,
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w700,
            fontSize: context.dw(32),
            height: 1.0,
            color: AppColors.primary,
          ),
        ),
      
      ],
    );
  }
}

class _SearchRow extends GetView<MessagesController> {
  const _SearchRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: context.dw(50),
            padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t16)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
              border: Border.all(color: AppColors.surfaceCard),
            ),
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
                    controller: controller.searchFieldController,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: context.dw(20),
                      height: 1.0,
                      color: AppColors.white,
                    ),
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'messages_search_hint'.tr,
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
          onTap: controller.onFilterTap,
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

class _FilterChips extends GetView<MessagesController> {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.filter.value;
      return Row(
        children: [
          _Chip(
            label: 'messages_filter_all'.tr,
            selected: selected == MessagesFilter.all,
            onTap: () => controller.setFilter(MessagesFilter.all),
          ),
          SizedBox(width: context.dw(AppSpacing.t10)),
          _Chip(
            label: 'messages_filter_unread'.tr,
            selected: selected == MessagesFilter.unread,
            onTap: () => controller.setFilter(MessagesFilter.unread),
          ),
        ],
      );
    });
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
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
        height: context.dw(37),
        padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t20)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
          border: selected
              ? Border.all(color: AppColors.primary, width: 0.5)
              : null,
          boxShadow: selected
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          label,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            fontSize: context.dw(20),
            height: 1.0,
            color: selected ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _DebugEmptyToggle extends GetView<MessagesController> {
  const _DebugEmptyToggle();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final empty = controller.debugShowEmpty.value;
      return Center(
        child: GestureDetector(
          onTap: controller.toggleDebugEmpty,
          child: Container(
            margin: EdgeInsets.only(top: context.dw(AppSpacing.t12)),
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
              empty ? 'Debug: show inbox' : 'Debug: empty state',
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
