import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/styles/app_colors.dart';

/// Circular business logo from profile — falls back to initials.
class AppBusinessLogo extends StatelessWidget {
  const AppBusinessLogo({
    super.key,
    required this.size,
    this.logoUrl = '',
    this.initials = '',
    this.borderColor,
  });

  final double size;
  final String logoUrl;
  final String initials;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.white.withValues(alpha: 0.35);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border.all(color: border, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: logoUrl.trim().isNotEmpty
          ? Image.network(
              logoUrl.trim(),
              fit: BoxFit.cover,
              width: size,
              height: size,
              errorBuilder: (_, _, _) => _Initials(
                initials: initials,
                size: size,
              ),
            )
          : _Initials(initials: initials, size: size),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({
    required this.initials,
    required this.size,
  });

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials.isNotEmpty ? initials : '•',
        style: GoogleFonts.cinzel(
          fontWeight: FontWeight.w500,
          fontSize: size * 0.36,
          height: 1.0,
          color: AppColors.accentGold,
        ),
      ),
    );
  }
}
