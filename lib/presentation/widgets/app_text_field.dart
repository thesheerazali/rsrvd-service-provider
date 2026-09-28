import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/extensions.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_images.dart';
import '../../core/styles/app_spacing.dart';

/// Figma auth input — transparent fill, `#242424` 1px stroke, 8px radius, 50h.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onToggleObscure,
    this.showObscureToggle = false,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onToggleObscure;
  final bool showObscureToggle;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w400,
      fontSize: context.dw(20),
      height: 1.2,
      color: AppColors.white,
    );
    final hintStyle = style.copyWith(
      color: AppColors.text.withValues(alpha: 0.5),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: style),
        SizedBox(height: context.dw(AppSpacing.t08)),
        SizedBox(
          height: context.dw(50),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            style: style,
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: hintStyle,
              filled: false,
              contentPadding: EdgeInsets.symmetric(
                horizontal: context.dw(AppSpacing.t20),
                vertical: context.dw(AppSpacing.t12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
                borderSide: const BorderSide(color: AppColors.surfaceCard),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              suffixIcon: showObscureToggle
                  ? IconButton(
                      onPressed: onToggleObscure,
                      icon: obscureText
                          ? SvgPicture.asset(
                              AppIcons.eyeClosed,
                              width: context.dw(15),
                              height: context.dw(15),
                              colorFilter: ColorFilter.mode(
                                AppColors.white.withValues(alpha: 0.5),
                                BlendMode.srcIn,
                              ),
                            )
                          : Icon(
                              Icons.visibility_outlined,
                              size: context.dw(16),
                              color: AppColors.white.withValues(alpha: 0.5),
                            ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
