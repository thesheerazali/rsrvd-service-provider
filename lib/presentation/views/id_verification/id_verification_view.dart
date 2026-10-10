import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/id_verification/id_verification_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/primary_button.dart';

/// OTP after Forgot Password — same Elite auth flow.
class IdVerificationView extends GetView<IdVerificationController> {
  const IdVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.auth,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.dw(AppSpacing.t30),
              context.dw(AppSpacing.t40),
              context.dw(AppSpacing.t30),
              context.dw(AppSpacing.t24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'id_verification_title'.tr.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.w700,
                    fontSize: context.dw(32),
                    height: 1.2,
                    letterSpacing: 0,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t15)),
                Text(
                  'id_verification_body'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w400,
                    fontSize: context.dw(24),
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (i) {
                    return _OtpBox(
                      controller: controller.digits[i],
                      focusNode: controller.focuses[i],
                      onChanged: (v) => controller.onDigitChanged(i, v),
                    );
                  }),
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                Obx(() {
                  final s = controller.secondsLeft.value;
                  final label = s > 0
                      ? 'code_expires'.trParams({
                          'time': '00:${s.toString().padLeft(2, '0')}s',
                        })
                      : 'code_expired'.tr;
                  return Text(
                    label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: context.dw(20),
                      color: AppColors.white,
                    ),
                  );
                }),
                SizedBox(height: context.dw(AppSpacing.t30)),
                PrimaryButton(
                  label: 'verify'.tr,
                  onPressed: controller.verify,
                ),
                SizedBox(height: context.dw(AppSpacing.t30)),
                Obx(() {
                  final canResend = controller.secondsLeft.value <= 0;
                  return Center(
                    child: GestureDetector(
                      onTap: canResend ? controller.resend : null,
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          style: GoogleFonts.darkerGrotesque(
                            fontWeight: FontWeight.w400,
                            fontSize: context.dw(24),
                            height: 1.0,
                            letterSpacing: 0,
                            color: AppColors.white,
                          ),
                          children: [
                            TextSpan(text: 'didnt_receive'.tr),
                            TextSpan(
                              text: 'resend_code'.tr,
                              style: GoogleFonts.darkerGrotesque(
                                fontWeight: FontWeight.w700,
                                fontSize: context.dw(24),
                                height: 1.0,
                                letterSpacing: 0,
                                color: canResend
                                    ? AppColors.white
                                    : AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.dw(AppSpacing.radiusSm));
    final borderW = context.dw(2);

    return SizedBox(
      width: context.dw(76),
      height: context.dw(75),
      child: ListenableBuilder(
        listenable: Listenable.merge([focusNode, controller]),
        builder: (context, _) {
          final focused = focusNode.hasFocus;
          final hasValue = controller.text.isNotEmpty;
          final borderColor = focused
              ? AppColors.primary
              : hasValue
                  ? AppColors.white
                  : AppColors.surfaceCard;

          return TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w600,
              fontSize: context.dw(28),
              color: AppColors.white,
            ),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.bg,
              enabledBorder: OutlineInputBorder(
                borderRadius: radius,
                borderSide: BorderSide(color: borderColor, width: borderW),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: radius,
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: borderW,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
