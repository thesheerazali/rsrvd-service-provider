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
    this.onSubmitted,
    this.maxLines = 1,
    this.prefixText,
    this.suffixIcon,
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
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final String? prefixText;

  /// Optional trailing icon (Material [Icon] or SVG [SvgPicture], etc.).
  final Widget? suffixIcon;

  bool get _isMultiline => maxLines > 1;

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(20),
      height: 1.2,
      color: AppColors.text,
    );
    final fieldStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w400,
      fontSize: context.dw(20),
      height: 1.2,
      color: AppColors.text,
    );
    final hintStyle = fieldStyle.copyWith(
      color: AppColors.text.withValues(alpha: 0.5),
    );

    final field = TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      onSubmitted: onSubmitted,
      maxLines: obscureText ? 1 : maxLines,
      style: fieldStyle,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintStyle,
        filled: false,
        // [prefix] stays visible even when empty; [prefixText] does not.
        prefix: prefixText == null
            ? null
            : Padding(
                padding: EdgeInsets.only(right: context.dw(4)),
                child: Text(
                  prefixText!,
                  style: fieldStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.dw(AppSpacing.t20),
          vertical: context.dw(_isMultiline ? AppSpacing.t16 : AppSpacing.t12),
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
            : suffixIcon == null
                ? null
                : Padding(
                    padding: EdgeInsets.only(right: context.dw(12)),
                    child: UnconstrainedBox(child: suffixIcon),
                  ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: labelStyle),
        SizedBox(height: context.dw(AppSpacing.t08)),
        if (_isMultiline) field else SizedBox(height: context.dw(50), child: field),
      ],
    );
  }
}
