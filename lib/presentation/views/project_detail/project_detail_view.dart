import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/models/project_detail.dart';
import '../../../core/models/project_item.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/project_detail/project_detail_controller.dart';
import '../../widgets/app_back_title_header.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_rich_card.dart';
import '../../widgets/app_spec_rows_card.dart';
import '../../widgets/app_status_pill.dart';
import '../../widgets/gold_divider.dart';
import '../../widgets/primary_button.dart';

/// Partners Project Detail — Figma `1196:4227` (+ completion variants).
/// Mirrors Elite overview/activities/documents; CTAs are SP-side.
class ProjectDetailView extends GetView<ProjectDetailController> {
  const ProjectDetailView({super.key});

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
                title: 'tab_projects'.tr,
                onBack: controller.goBack,
                titleWeight: FontWeight.w600,
                trailing:
                    kDebugMode ? const _DebugCompletionMenu() : null,
              ),
              Expanded(
                child: Obx(() {
                  final loading = controller.isLoading.value;
                  final item = controller.detail.value;
                  final tab = controller.selectedTabIndex.value;

                  if (loading && item == null) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  if (item == null) return const SizedBox.shrink();

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (item.showIssueBanner) ...[
                              _IssueRaisedBanner(note: item.issueNote),
                              SizedBox(height: context.dw(AppSpacing.t20)),
                            ],
                            _TitleCard(item: item),
                            if (item.showPostUpdate) ...[
                              SizedBox(height: context.dw(AppSpacing.t30)),
                              const _PostUpdateCard(),
                            ],
                            SizedBox(height: context.dw(AppSpacing.t30)),
                            const GoldDivider(),
                            SizedBox(height: context.dw(AppSpacing.t30)),
                            _TabPills(
                              tabs: item.tabs,
                              selectedIndex: tab,
                              onSelected: controller.selectTab,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(
                            context.dw(AppSpacing.t30),
                            context.dw(AppSpacing.t30),
                            context.dw(AppSpacing.t30),
                            context.dw(AppSpacing.t40),
                          ),
                          children: [
                            if (tab == 0)
                              _OverviewBody(item: item)
                            else if (tab == 1)
                              _ActivitiesBody(activities: item.activities)
                            else
                              _DocumentsBody(
                                documents: item.documents,
                                onReview: controller.reviewDocument,
                              ),
                            SizedBox(height: context.dw(AppSpacing.t30)),
                            const GoldDivider(),
                            SizedBox(height: context.dw(AppSpacing.t30)),
                            _FooterActions(item: item),
                            SizedBox(height: context.dw(AppSpacing.t40)),
                          ],
                        ),
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

class _FooterActions extends GetView<ProjectDetailController> {
  const _FooterActions({required this.item});

  final ProjectDetail item;

  @override
  Widget build(BuildContext context) {
    if (item.canCompleteProject) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryButton(
            label: item.secondaryCtaLabel.isEmpty
                ? 'Complete Project'
                : item.secondaryCtaLabel,
            onPressed: controller.completeProject,
          ),
          SizedBox(height: context.dw(AppSpacing.t10)),
          PrimaryButton(
            label: item.ctaLabel,
            outlined: true,
            onPressed: controller.chatWithMember,
          ),
          if (item.canCancelProject) ...[
            SizedBox(height: context.dw(AppSpacing.t16)),
            Center(
              child: GestureDetector(
                onTap: controller.cancelProject,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Cancel Project',
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w600,
                    fontSize: context.dw(18),
                    height: 1.2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    }

    if (item.canResubmitCompletion) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: GestureDetector(
              onTap: controller.chatWithMember,
              behavior: HitTestBehavior.opaque,
              child: Text(
                item.ctaLabel,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w600,
                  fontSize: context.dw(20),
                  height: 1.2,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: context.dw(AppSpacing.t16)),
          PrimaryButton(
            label: item.secondaryCtaLabel.isEmpty
                ? 'Resubmit Completion'
                : item.secondaryCtaLabel,
            onPressed: controller.resubmitCompletion,
          ),
        ],
      );
    }

    return PrimaryButton(
      label: item.ctaLabel,
      onPressed: controller.chatWithMember,
    );
  }
}

class _IssueRaisedBanner extends StatelessWidget {
  const _IssueRaisedBanner({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t20), vertical: context.dw(AppSpacing.t10)),
      decoration: BoxDecoration(
        color: AppColors.errorAlt.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusLg)),
        border: Border.all(color: AppColors.surfaceCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Issue raised by member',
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(16),
              height: 1.2,
              color: AppColors.errorAlt,
            ),
          ),
          if (note.isNotEmpty) ...[
            SizedBox(height: context.dw(AppSpacing.t08)),
            Text(
              note,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(16),
                height: 1.2,
                color: AppColors.errorAlt,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PostUpdateCard extends GetView<ProjectDetailController> {
  const _PostUpdateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusLg)),
      
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Post an Update',
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.w600,
              fontSize: context.dw(20),
              height: 1.0,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: context.dw(AppSpacing.t16)),
          Container(
            height: context.dw(50),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
              border: Border.all(color: AppColors.surfaceCard),
            ),
            padding: EdgeInsets.only(left: context.dw(AppSpacing.t16)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.updateController,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: context.dw(18),
                      height: 1.0,
                      color: AppColors.text,
                    ),
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Share daily Progress',
                      hintStyle: GoogleFonts.darkerGrotesque(
                        fontWeight: FontWeight.w400,
                        fontSize: context.dw(18),
                        height: 1.0,
                        color: AppColors.text.withValues(alpha: 0.5),
                      ),
                    ),
                    onSubmitted: (_) => controller.postUpdate(),
                  ),
                ),
                GestureDetector(
                  onTap: controller.postUpdate,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: context.dw(37),
                    margin: EdgeInsets.only(right: context.dw(AppSpacing.t08)),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.dw(AppSpacing.t20),
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        context.dw(AppSpacing.radiusSm),
                      ),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Text(
                      'Add',
                      style: GoogleFonts.darkerGrotesque(
                        fontWeight: FontWeight.w600,
                        fontSize: context.dw(16),
                        height: 1.0,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DebugCompletionMenu extends GetView<ProjectDetailController> {
  const _DebugCompletionMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProjectCompletionStatus>(
      tooltip: 'Debug completion',
      onSelected: controller.debugSetCompletion,
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: ProjectCompletionStatus.none,
          child: Text('Active (reset)'),
        ),
        PopupMenuItem(
          value: ProjectCompletionStatus.paymentOnHold,
          child: Text('Hold · Contract'),
        ),
        PopupMenuItem(
          value: ProjectCompletionStatus.providerMarkedComplete,
          child: Text('Held · Awaiting'),
        ),
        PopupMenuItem(
          value: ProjectCompletionStatus.memberApproved,
          child: Text('Member approved'),
        ),
        PopupMenuItem(
          value: ProjectCompletionStatus.issueRaised,
          child: Text('Issue raised'),
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.dw(AppSpacing.t12),
          vertical: context.dw(6),
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
        ),
        child: Text(
          'Debug',
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w600,
            fontSize: context.dw(14),
            height: 1.0,
            color: AppColors.muted,
          ),
        ),
      ),
    );
  }
}

class _TitleCard extends StatelessWidget {
  const _TitleCard({required this.item});

  final ProjectDetail item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusLg)),
        border: Border.all(color: AppColors.surfaceCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.category,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: context.dw(18),
                    height: 1.0,
                    color: AppColors.text.withValues(alpha: 0.5),
                  ),
                ),
              ),
              _StatusPill(tone: item.statusTone, label: item.status),
            ],
          ),
          SizedBox(height: context.dw(AppSpacing.t07)),
          Text(
            item.title,
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.w600,
              fontSize: context.dw(24),
              height: 1.0,
              letterSpacing: 0,
              color: AppColors.white,
            ),
          ),
          if (item.subtitle.isNotEmpty) ...[
            SizedBox(height: context.dw(AppSpacing.t07)),
            Text(
              item.subtitle,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(18),
                height: 1.0,
                color: AppColors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.tone, required this.label});

  final ProjectStatusTone tone;
  final String label;

  @override
  Widget build(BuildContext context) {
    // Active + Completed share the soft green pill (Figma).
    if (tone == ProjectStatusTone.active ||
        tone == ProjectStatusTone.completed) {
      return AppStatusPill(label: label);
    }

    final (color, surface) = switch (tone) {
      ProjectStatusTone.cancelled => (
          AppColors.muted,
          const Color(0x0D818181),
        ),
      // Issue Raised
      _ => (
          AppColors.error,
          AppColors.error.withValues(alpha: 0.08),
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dw(15),
        vertical: context.dw(3),
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.dw(3),
            height: context.dw(3),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: context.dw(3)),
          Text(
            label,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(14),
              height: 1.0,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabPills extends StatelessWidget {
  const _TabPills({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            _TabPill(
              label: tabs[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
            if (i != tabs.length - 1)
              SizedBox(width: context.dw(AppSpacing.t10)),
          ],
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
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
          color: selected ? AppColors.primary : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
          border: selected
              ? Border.all(color: AppColors.primary, width: 0.5)
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            fontSize: context.dw(20),
            height: 1.0,
            color: selected
                ? AppColors.white
                : AppColors.primary.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}

class _OverviewBody extends StatelessWidget {
  const _OverviewBody({required this.item});

  final ProjectDetail item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSpecRowsCard(rows: item.overviewRows),
        if (item.showCompletionBanner) ...[
          SizedBox(height: context.dw(AppSpacing.t20)),
          const _AwaitingConfirmationBanner(),
        ],
        if (item.adminNotes.isNotEmpty || item.attachmentLabel.isNotEmpty) ...[
          SizedBox(height: context.dw(AppSpacing.t30)),
          _AdminNotesCard(
            notes: item.adminNotes,
            attachmentLabel: item.attachmentLabel,
          ),
        ],
        if (item.hasContractSection) ...[
          SizedBox(height: context.dw(AppSpacing.t30)),
          const GoldDivider(),
          SizedBox(height: context.dw(AppSpacing.t30)),
          if (item.contractSectionTitle.isNotEmpty) ...[
            Text(
              item.contractSectionTitle,
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(20),
                height: 1.0,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: context.dw(AppSpacing.t20)),
          ],
          if (item.contract != null)
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: context.dw(290),
                child: AppRichCard(card: item.contract!.toRichCard()),
              ),
            ),
          if (item.payment != null) ...[
            SizedBox(height: context.dw(AppSpacing.t10)),
            _PaymentCard(payment: item.payment!),
          ],
        ],
      ],
    );
  }
}

class _AwaitingConfirmationBanner extends StatelessWidget {
  const _AwaitingConfirmationBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t20), vertical: context.dw(AppSpacing.t10)),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
        
      ),
      child: Text(
        'Awaiting member confirmation of completion. Payment is released '
        'once the member accepts.',
        textAlign: TextAlign.center,
        style: GoogleFonts.darkerGrotesque(
          fontWeight: FontWeight.w500,
          fontSize: context.dw(16),
          height: 1.2,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _ActivitiesBody extends StatelessWidget {
  const _ActivitiesBody({required this.activities});

  final List<ProjectActivity> activities;

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Text(
        'No activity yet',
        textAlign: TextAlign.center,
        style: GoogleFonts.darkerGrotesque(
          fontWeight: FontWeight.w500,
          fontSize: context.dw(20),
          color: AppColors.text.withValues(alpha: 0.5),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < activities.length; i++) ...[
          _ActivityRow(item: activities[i]),
          Divider(
            height: context.dw(AppSpacing.t40),
            thickness: 1,
            color: AppColors.surfaceCard,
          ),
        ],
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});

  final ProjectActivity item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.body,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w500,
            fontSize: context.dw(20),
            height: 1.2,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t08)),
        Text(
          item.timeLabel,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w500,
            fontSize: context.dw(14),
            height: 1.0,
            color: AppColors.text.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _DocumentsBody extends StatelessWidget {
  const _DocumentsBody({
    required this.documents,
    required this.onReview,
  });

  final List<ProjectDocument> documents;
  final ValueChanged<ProjectDocument> onReview;

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return Text(
        'No documents yet',
        textAlign: TextAlign.center,
        style: GoogleFonts.darkerGrotesque(
          fontWeight: FontWeight.w500,
          fontSize: context.dw(20),
          color: AppColors.text.withValues(alpha: 0.5),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < documents.length; i++) ...[
          _DocumentRow(
            item: documents[i],
            onReview: () => onReview(documents[i]),
          ),
          Divider(
            height: context.dw(AppSpacing.t40),
            thickness: 1,
            color: AppColors.surfaceCard,
          ),
        ],
      ],
    );
  }
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({
    required this.item,
    required this.onReview,
  });

  final ProjectDocument item;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: context.dw(20),
                  height: 1.2,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: context.dw(AppSpacing.t08)),
              Text(
                item.meta,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: context.dw(14),
                  height: 1.0,
                  color: AppColors.text.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: context.dw(AppSpacing.t12)),
        GestureDetector(
          onTap: onReview,
          behavior: HitTestBehavior.opaque,
          child: Text(
            item.actionLabel,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w600,
              fontSize: context.dw(16),
              height: 1.2,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final ProjectPaymentBlock payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
        border: Border.all(color: AppColors.surfaceCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Payment',
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(14),
              height: 1.0,
              color: AppColors.text.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: context.dw(AppSpacing.t10)),
          Text(
            payment.amountLabel,
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.w600,
              fontSize: context.dw(24),
              height: 1.0,
              color: AppColors.primary,
            ),
          ),
          if (payment.note.isNotEmpty) ...[
            SizedBox(height: context.dw(AppSpacing.t10)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.dw(AppSpacing.t12)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
                border: Border.all(color: AppColors.surfaceCard),
              ),
              child: Text(
                payment.note,
                textAlign: TextAlign.left,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: context.dw(14),
                  height: 1.2,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
          if (payment.statusLabel.isNotEmpty) ...[
            SizedBox(height: context.dw(AppSpacing.t10)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.dw(AppSpacing.t15),
                vertical: context.dw(3),
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius:
                    BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: context.dw(3),
                    height: context.dw(3),
                    decoration: const BoxDecoration(
                      color: AppColors.muted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: context.dw(5)),
                  Text(
                    payment.statusLabel,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(14),
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AdminNotesCard extends StatelessWidget {
  const _AdminNotesCard({
    required this.notes,
    required this.attachmentLabel,
  });

  final String notes;
  final String attachmentLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusLg)),
        border: Border.all(color: AppColors.surfaceCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notes.isNotEmpty) ...[
            Text(
              'Admin Notes',
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(14),
                height: 1.0,
                color: AppColors.text.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: context.dw(AppSpacing.t05)),
            Text(
              notes,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(16),
                height: 1.0,
                color: AppColors.white,
              ),
            ),
          ],
          if (attachmentLabel.isNotEmpty) ...[
            SizedBox(height: context.dw(AppSpacing.t10)),
            Container(
              padding: EdgeInsets.all(context.dw(AppSpacing.t10)),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius:
                    BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppIcons.iconDoc,
                    width: context.dw(17),
                    height: context.dw(17),
                  ),
                  SizedBox(width: context.dw(AppSpacing.t05)),
                  Text(
                    attachmentLabel,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(16),
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
