import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/models/app_spec_row.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_spacing.dart';
import 'app_status_pill.dart';

/// Label / value table used on property, investment, and partner detail.
class AppSpecRowsCard extends StatelessWidget {
  const AppSpecRowsCard({super.key, required this.rows});

  final List<AppSpecRow> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
        border: Border.all(color: AppColors.surfaceCard, width: 0.5),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.dw(AppSpacing.t20),
                vertical: context.dw(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      rows[i].label,
                      style: GoogleFonts.darkerGrotesque(
                        fontWeight: FontWeight.w400,
                        fontSize: context.dw(18),
                        height: 1.2,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _SpecValue(value: rows[i].value),
                    ),
                  ),
                ],
              ),
            ),
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

class _SpecValue extends StatelessWidget {
  const _SpecValue({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    // Partners Figma: Completed stage uses same green pill as Active.
    if (value == 'Completed' || value == 'Active') {
      return AppStatusPill(label: value);
    }

    return Text(
      value,
      textAlign: TextAlign.right,
      style: GoogleFonts.darkerGrotesque(
        fontWeight: FontWeight.w600,
        fontSize: context.dw(20),
        height: 1.2,
        color: AppColors.white,
      ),
    );
  }
}
