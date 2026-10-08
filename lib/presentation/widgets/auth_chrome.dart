import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import '../../core/styles/app_spacing.dart';
import 'brand_logo.dart';

export 'brand_logo.dart';

/// Cinzel eyebrow + gold title, centered (Sign In / Sign Up).
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.eyebrow,
    required this.title,
  });

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BrandLogoHeader(),
        SizedBox(height: context.dw(AppSpacing.t30)),
        Text(
          eyebrow.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w400,
            fontSize: context.dw(24),
            height: 1.2,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t08)),
        Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w700,
            fontSize: context.dw(32),
            height: 1.2,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: context.dw(1), color: AppColors.surfaceCard),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t10)),
          child: Text(
            'OR',
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(14),
              color: AppColors.text,
            ),
          ),
        ),
        line,
      ],
    );
  }
}

class SocialAuthRow extends StatelessWidget {
  const SocialAuthRow({
    super.key,
    this.onGoogle,
    this.onApple,
  });

  final VoidCallback? onGoogle;
  final VoidCallback? onApple;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onGoogle,
          child: SvgPicture.asset(
            AppIcons.google,
            width: context.dw(32),
            height: context.dw(32),
          ),
        ),
        SizedBox(width: context.dw(AppSpacing.t20)),
        InkWell(
          onTap: onApple,
          child: SvgPicture.asset(
            AppIcons.apple,
            width: context.dw(28),
            height: context.dw(33),
          ),
        ),
      ],
    );
  }
}

/// Footer link — action text is brand primary (`#CC5500`), per Figma.
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.leading,
    required this.action,
    required this.onTap,
  });

  final String leading;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w500,
            fontSize: context.dw(20),
            height: 1.2,
            color: AppColors.white,
          ),
          children: [
            TextSpan(text: leading),
            TextSpan(
              text: action,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
