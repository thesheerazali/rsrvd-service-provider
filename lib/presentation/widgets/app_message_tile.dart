import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/models/conversation_thread.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Reusable inbox row — Elite-aligned [ConversationThread] shape.
class AppMessageTile extends StatelessWidget {
  const AppMessageTile({
    super.key,
    required this.thread,
    this.onTap,
    this.showDivider = true,
  });

  final ConversationThread thread;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: context.dw(AppSpacing.t20)),
        decoration: BoxDecoration(
          color: AppColors.bg,
          border: showDivider
              ? const Border(
                  bottom: BorderSide(color: AppColors.surfaceCard, width: 1),
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.dw(50),
              height: context.dw(50),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
              ),
              child: Text(
                thread.counterpartInitials.isNotEmpty
                    ? thread.counterpartInitials
                    : _initials(thread.counterpartName),
                style: GoogleFonts.cinzel(
                  fontWeight: FontWeight.w500,
                  fontSize: context.dw(14),
                  height: 1.0,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: context.dw(AppSpacing.t10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          thread.subject.categoryLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.darkerGrotesque(
                            fontWeight: FontWeight.w500,
                            fontSize: context.dw(14),
                            height: 1.0,
                            color: AppColors.text.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (thread.hasUnread) ...[
                            Container(
                              width: context.dw(6),
                              height: context.dw(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: context.dw(AppSpacing.t05)),
                          ],
                          Text(
                            thread.timeLabel,
                            style: GoogleFonts.darkerGrotesque(
                              fontWeight: FontWeight.w500,
                              fontSize: context.dw(14),
                              height: 1.0,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: context.dw(AppSpacing.t10)),
                  Text(
                    thread.counterpartName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(20),
                      height: 1.0,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: context.dw(AppSpacing.t05)),
                  Text(
                    thread.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(16),
                      height: 1.0,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return ('${parts.first[0]}${parts.last[0]}').toUpperCase();
  }
}
