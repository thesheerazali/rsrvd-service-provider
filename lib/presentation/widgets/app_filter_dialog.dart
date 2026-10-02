import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/models/app_filter_config.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';

/// Shared Filters & Sorting sheet — Figma `1001:2027`.
///
/// Same shell everywhere; pass [AppFilterConfig] for screen-specific chips.
/// Chips hug content and wrap (not full-width stacks).
class AppFilterDialog extends StatefulWidget {
  const AppFilterDialog({
    super.key,
    required this.config,
    this.initial,
  });

  final AppFilterConfig config;
  final AppFilterSelection? initial;

  /// Returns the working selection when the sheet is dismissed.
  static Future<AppFilterSelection?> show({
    required AppFilterConfig config,
    AppFilterSelection? initial,
    bool barrierDismissible = true,
  }) {
    return Get.dialog<AppFilterSelection>(
      AppFilterDialog(config: config, initial: initial),
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.72),
    );
  }

  @override
  State<AppFilterDialog> createState() => _AppFilterDialogState();
}

class _AppFilterDialogState extends State<AppFilterDialog> {
  late AppFilterSelection _selected;

  @override
  void initState() {
    super.initState();
    _selected = {
      for (final section in widget.config.sections)
        section.id: Set<String>.from(widget.initial?[section.id] ?? const {}),
    };
    if (widget.initial == null) {
      _applyDefaults();
    }
  }

  void _applyDefaults() {
    for (final section in widget.config.sections) {
      if (_selected[section.id]!.isNotEmpty) continue;
      if (section.options.isEmpty) continue;
      _selected[section.id] = {section.options.first.id};
    }
  }

  void _clearAll() {
    setState(() {
      for (final section in widget.config.sections) {
        _selected[section.id] = {};
      }
    });
  }

  void _toggle(AppFilterSection section, String optionId) {
    setState(() {
      final current = _selected[section.id] ?? <String>{};
      if (section.multiSelect) {
        if (current.contains(optionId)) {
          current.remove(optionId);
        } else {
          current.add(optionId);
        }
        _selected[section.id] = current;
      } else {
        _selected[section.id] = {optionId};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Figma frame content width 330 + side inset 25 → dialog sits in 30 inset.
    final radius = context.dw(AppSpacing.radiusLg);
    final config = widget.config;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Get.back(result: _selected);
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding:
            EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t30)),
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.dw(25),
              context.dw(AppSpacing.t40),
              context.dw(25),
              context.dw(AppSpacing.t40),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        config.title,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w600,
                          fontSize: context.dw(20),
                          height: 1.2,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _clearAll,
                      child: Text(
                        config.clearLabel,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(18),
                          height: 1.2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                // Figma: title @ y40 → sections @ y93 ≈ 29–30px gap.
                SizedBox(height: context.dw(AppSpacing.t30)),
                for (var i = 0; i < config.sections.length; i++) ...[
                  if (i > 0) SizedBox(height: context.dw(AppSpacing.t10)),
                  _SectionBlock(
                    section: config.sections[i],
                    selected: _selected[config.sections[i].id] ?? const {},
                    onToggle: (id) => _toggle(config.sections[i], id),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.section,
    required this.selected,
    required this.onToggle,
  });

  final AppFilterSection section;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w400,
            fontSize: context.dw(20),
            height: 1.2,
            color: AppColors.white,
          ),
        ),
        // Figma section gap title → chips = 14.
        SizedBox(height: context.dw(14)),
        Wrap(
          spacing: context.dw(AppSpacing.t10),
          runSpacing: context.dw(AppSpacing.t10),
          alignment: WrapAlignment.start,
          children: [
            for (final option in section.options)
              _FilterChip(
                label: option.label,
                selected: selected.contains(option.id),
                onTap: () => onToggle(option.id),
              ),
          ],
        ),
      ],
    );
  }
}

/// Figma chip — hug width, h 37, pad-x 20, radius pill.
/// Selected: primary fill + white text. Unselected: primary @ 10% + primary text.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: context.dw(37),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(context.dw(AppSpacing.radiusPill)),
          ),
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t20)),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w400,
                  fontSize: context.dw(20),
                  height: 1.0,
                  color: selected ? AppColors.white : AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
