import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsrvd_service_provider/presentation/widgets/gold_divider.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/create_contract/create_contract_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_detail_back_header.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

/// Create Contract form — Partners-only; produces Elite-aligned [ChatRichCard].
class CreateContractView extends GetView<CreateContractController> {
  const CreateContractView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(
          child: Column(
            children: [
              AppDetailBackHeader(onBack: controller.goBack),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t20),
                    context.dw(AppSpacing.t30),
                    context.dw(AppSpacing.t30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        controller.memberName,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(20),
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      Text(
                        'create_contract_title'.tr,
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.w600,
                          fontSize: context.dw(24),
                          height: 1.0,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      AppTextField(
                        label: 'contract_title_label'.tr,
                        hint: 'contract_title_hint'.tr,
                        controller: controller.titleController,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t20)),
                      Obx(() {
                        return _AppDropdownField(
                          label: 'contract_category_label'.tr,
                          value: controller.categoryLabel.value,
                          options: controller.categories,
                          onChanged: controller.setCategory,
                        );
                      }),
                      SizedBox(height: context.dw(AppSpacing.t20)),
                      AppTextField(
                        label: 'contract_scope_label'.tr,
                        hint: 'contract_scope_hint'.tr,
                        controller: controller.scopeController,
                        maxLines: 4,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t20)),
                      AppTextField(
                        label: 'contract_price_label'.tr,
                        hint: '00.00',
                        controller: controller.priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        prefixText: r'$',
                      ),
                      SizedBox(height: context.dw(AppSpacing.t20)),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'contract_date_label'.tr,
                              hint: 'Date',
                              controller: controller.dateController,
                              suffixIcon: SvgPicture.asset(
                                AppIcons.calendarIcon,
                                width: context.dw(20),
                                height: context.dw(20),
                              ),
                            ),
                          ),
                          SizedBox(width: context.dw(AppSpacing.t10)),
                          Expanded(
                            child: AppTextField(
                              label: 'contract_time_label'.tr,
                              hint: 'Time',
                              controller: controller.timeController,
                              suffixIcon: SvgPicture.asset(
                                AppIcons.clockIcon,
                                width: context.dw(20),
                                height: context.dw(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.dw(AppSpacing.t20)),
                      AppTextField(
                        label: 'contract_location_label'.tr,
                        hint: 'Address',
                        controller: controller.locationController,
                        maxLines: 3,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t20)),
                      Text(
                        'contract_attachments_label'.tr,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(20),
                          height: 1.2,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t08)),
                      GestureDetector(
                        onTap: controller.attachDocument,
                        child: Container(
                          height: context.dw(50),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              context.dw(AppSpacing.radiusSm),
                            ),
                            border: Border.all(color: AppColors.surfaceCard),
                          ),
                          child: Text(
                            'contract_attach_cta'.tr,
                            style: GoogleFonts.darkerGrotesque(
                              fontWeight: FontWeight.w400,
                              fontSize: context.dw(20),
                              height: 1.2,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        final name = controller.attachmentLabel.value;
                        if (name.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(
                            top: context.dw(AppSpacing.t12),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(context.dw(AppSpacing.t16)),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(250, 74, 24, 0.05),
                              borderRadius: BorderRadius.circular(
                                context.dw(AppSpacing.radiusMd),
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.iconDoc,
                                  width: context.dw(20),
                                  height: context.dw(20),
                                ),
                                SizedBox(width: context.dw(AppSpacing.t10)),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: GoogleFonts.darkerGrotesque(
                                      fontWeight: FontWeight.w500,
                                      fontSize: context.dw(16),
                                      color: AppColors.text,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: controller.removeAttachment,
                                  child: Icon(
                                    Icons.close,
                                    size: context.dw(18),
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      GoldDivider(),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      PrimaryButton(
                        label: 'contract_preview_cta'.tr,
                        onPressed: controller.previewContract,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Same chrome as [AppTextField] — label + 50h outlined control.
class _AppDropdownField extends StatelessWidget {
  const _AppDropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: labelStyle),
        SizedBox(height: context.dw(AppSpacing.t08)),
        SizedBox(
          height: context.dw(50),
          child: InputDecorator(
            decoration: InputDecoration(
              filled: false,
              contentPadding: EdgeInsets.symmetric(
                horizontal: context.dw(AppSpacing.t20),
                vertical: 0,
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
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                isDense: true,
                dropdownColor: AppColors.surface,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.white.withValues(alpha: 0.5),
                  size: context.dw(20),
                ),
                style: fieldStyle,
                items: options
                    .map(
                      (o) => DropdownMenuItem(
                        value: o,
                        child: Text(o, style: fieldStyle),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
