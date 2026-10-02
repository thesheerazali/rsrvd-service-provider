import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/models/chat_message.dart';
import '../../../core/models/chat_subject.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/chat_detail/chat_detail_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_rich_card.dart';

/// Chat thread — Elite bubble / rich-card architecture + Partners Create Contract.
class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(
          child: Obx(() {
            final loading = controller.isLoading.value;
            final thread = controller.thread.value;
            final items = controller.messages.toList();

            if (loading && thread == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (thread == null) return const SizedBox.shrink();

            return Column(
              children: [
                const _ChatTopBar(),
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
                      _CounterpartBlock(
                        name: thread.counterpartName,
                        initials: thread.counterpartInitials,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      _SubjectCard(subject: thread.subject),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      context.dw(AppSpacing.t30),
                      context.dw(AppSpacing.t10),
                      context.dw(AppSpacing.t30),
                      context.dw(AppSpacing.t20),
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: context.dw(AppSpacing.t10),
                        ),
                        child: _MessageBubble(
                          message: items[i],
                          onCta: controller.onRichCardCta,
                        ),
                      );
                    },
                  ),
                ),
                if (controller.showDebugEliteAccept)
                  const _DebugEliteAcceptButton(),
                const _Composer(),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _DebugEliteAcceptButton extends GetView<ChatDetailController> {
  const _DebugEliteAcceptButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.dw(AppSpacing.t30),
        0,
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t08),
      ),
      child: Center(
        child: GestureDetector(
          onTap: controller.debugSimulateEliteAccept,
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
              'Debug: Elite accepts contract',
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w500,
                fontSize: context.dw(12),
                color: AppColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatTopBar extends GetView<ChatDetailController> {
  const _ChatTopBar();

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
      child: Obx(() {
        final viewProjects = controller.showViewInProjects;
        return Row(
          children: [
            Expanded(
              child: Text(
                'messages_top_title'.tr,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: context.dw(24),
                  height: 1.2,
                  color: AppColors.text,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.onContractHeaderAction,
              child: Container(
                height: context.dw(40),
                padding: EdgeInsets.symmetric(
                  horizontal: context.dw(AppSpacing.t12),
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                  color: const Color.fromRGBO(250, 74, 24, 0.05),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(viewProjects ? AppIcons.viewIcon : AppIcons.contractIcon),
                    SizedBox(width: context.dw(10)),
                    Text(
                      viewProjects
                          ? 'view_in_projects_cta'.tr
                          : 'create_contract_cta'.tr,
                      style: GoogleFonts.darkerGrotesque(
                        fontWeight: FontWeight.w600,
                        fontSize: context.dw(18),
                        height: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _CounterpartBlock extends StatelessWidget {
  const _CounterpartBlock({required this.name, required this.initials});

  final String name;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.dw(50),
          height: context.dw(50),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Text(
            initials,
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(14),
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: context.dw(AppSpacing.t10)),
        Expanded(
          child: Text(
            name.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.w600,
              fontSize: context.dw(24),
              height: 1.0,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.subject});

  final ChatSubject subject;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusMd)),
        border: Border.all(color: AppColors.surfaceCard, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject.categoryLabel,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w400,
              fontSize: context.dw(14),
              height: 1.0,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: context.dw(5)),
          Text(
            subject.title.toUpperCase(),
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(18),
              height: 1.0,
              color: AppColors.primary,
            ),
          ),
          if (subject.metaLine.isNotEmpty) ...[
            SizedBox(height: context.dw(5)),
            Text(
              subject.metaLine,
              style: GoogleFonts.darkerGrotesque(
                fontWeight: FontWeight.w600,
                fontSize: context.dw(14),
                height: 1.0,
                color: AppColors.text,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.onCta});

  final ChatMessage message;
  final ValueChanged<ChatRichCard> onCta;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final radius = BorderRadius.only(
      topLeft: Radius.circular(context.dw(40)),
      topRight: Radius.circular(context.dw(10)),
      bottomRight: Radius.circular(context.dw(10)),
      bottomLeft: Radius.circular(context.dw(10)),
    );

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(right: mine ? 0 : context.dw(AppSpacing.t30)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.dw(330)),
          child: Column(
            crossAxisAlignment:
                mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                width: message.richCard != null ? context.dw(330) : null,
                padding: EdgeInsets.all(context.dw(AppSpacing.t20)),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: radius,
                ),
                child: _BubbleContent(message: message, onCta: onCta),
              ),
              SizedBox(height: context.dw(12)),
              Text(
                message.timeLabel,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: context.dw(16),
                  height: 1.0,
                  letterSpacing: -0.16,
                  color: AppColors.text.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BubbleContent extends StatelessWidget {
  const _BubbleContent({required this.message, required this.onCta});

  final ChatMessage message;
  final ValueChanged<ChatRichCard> onCta;

  @override
  Widget build(BuildContext context) {
    final hasText = message.body.trim().isNotEmpty;
    final card = message.richCard;
    // Service inquiry: member text + linked service card in one bubble.
    if (hasText && card != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TextBody(message: message),
          SizedBox(height: context.dw(AppSpacing.t16)),
          AppRichCard(card: card, onCta: onCta),
        ],
      );
    }
    if (card != null) {
      return AppRichCard(card: card, onCta: onCta);
    }
    return _TextBody(message: message);
  }
}

class _TextBody extends StatelessWidget {
  const _TextBody({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w400,
      fontSize: context.dw(20),
      height: 22 / 20,
      color: AppColors.text,
    );
    if (message.emphasisSuffix.isEmpty) {
      return Text(message.body, style: base);
    }
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: '${message.body}\n\n'),
          TextSpan(
            text: message.emphasisSuffix,
            style: base.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _Composer extends GetView<ChatDetailController> {
  const _Composer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t10),
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t20),
      ),
      child: Container(
        height: context.dw(61),
        padding: EdgeInsets.symmetric(horizontal: context.dw(10)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
          border: Border.all(color: AppColors.surfaceCard),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: controller.attach,
              child: Container(
                width: context.dw(41),
                height: context.dw(41),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppIcons.iconChatAttachment,
                  width: context.dw(21),
                  height: context.dw(21),
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: context.dw(12)),
            Expanded(
              child: TextField(
                controller: controller.composerController,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w400,
                  fontSize: context.dw(18),
                  height: 1.2,
                  color: AppColors.text,
                ),
                cursorColor: AppColors.primary,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'chat_composer_hint'.tr,
                  hintStyle: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w400,
                    fontSize: context.dw(18),
                    height: 1.2,
                    color: AppColors.text.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.sendMessage,
              child: Container(
                width: context.dw(41),
                height: context.dw(41),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppIcons.iconSend,
                  width: context.dw(21),
                  height: context.dw(21),
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
