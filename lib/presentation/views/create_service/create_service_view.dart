import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/create_service/create_service_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_detail_back_header.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

/// Create a New Service — Figma; fonts/chrome match List Property + Create Contract.
class CreateServiceView extends GetView<CreateServiceController> {
  const CreateServiceView({super.key});

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
                      Obx(() {
                        return Text(
                          controller.screenTitle,
                          style: GoogleFonts.cinzel(
                            fontWeight: FontWeight.w600,
                            fontSize: context.dw(24),
                            height: 1.0,
                            color: AppColors.white,
                          ),
                        );
                      }),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      AppTextField(
                        label: 'create_service_name_label'.tr,
                        hint: 'create_service_name_hint'.tr,
                        controller: controller.nameController,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t20)),
                      Obx(() {
                        return _AppDropdownField(
                          label: 'create_service_category_label'.tr,
                          value: controller.category.value,
                          options: controller.categories,
                          onChanged: controller.setCategory,
                        );
                      }),
                      SizedBox(height: context.dw(AppSpacing.t20)),
                      AppTextField(
                        label: 'create_service_description_label'.tr,
                        hint: 'create_service_description_hint'.tr,
                        controller: controller.descriptionController,
                        maxLines: 4,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t20)),
                      AppTextField(
                        label: 'create_service_price_label'.tr,
                        hint: '00.00',
                        controller: controller.priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        prefixText: r'$',
                      ),
                      SizedBox(height: context.dw(AppSpacing.t20)),
                      Text(
                        'create_service_images_label'.tr,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(20),
                          height: 1.2,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      Obx(() {
                        final slots = controller.imageSlots.toList();
                        return Wrap(
                          spacing: context.dw(AppSpacing.t10),
                          runSpacing: context.dw(AppSpacing.t10),
                          children: [
                            for (var i = 0; i < slots.length; i++)
                              _ImageTile(
                                onRemove: () =>
                                    controller.removeImageSlot(i),
                              ),
                            if (controller.canAddImage)
                              _AddImageTile(onTap: controller.addImageSlot),
                          ],
                        );
                      }),
                      SizedBox(height: context.dw(AppSpacing.t40)),
                      Obx(() {
                        final busy = controller.isPublishing.value;
                        return PrimaryButton(
                          label: controller.primaryCtaLabel,
                          enabled: !busy,
                          onPressed: controller.publish,
                        );
                      }),
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

class _AddImageTile extends StatelessWidget {
  const _AddImageTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = context.dw(100);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
          border: Border.all(color: AppColors.surfaceCard),
        ),
        child: Icon(
          Icons.add,
          size: context.dw(28),
          color: AppColors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({required this.onRemove});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final size = context.dw(100);
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius:
                BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
            border: Border.all(color: AppColors.surfaceCard),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.image_outlined,
            size: context.dw(28),
            color: AppColors.muted,
          ),
        ),
        Positioned(
          top: context.dw(4),
          right: context.dw(4),
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: context.dw(22),
              height: context.dw(22),
              decoration: const BoxDecoration(
                color: AppColors.surfaceCard,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: context.dw(14),
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Same chrome as [AppTextField] — used for category on Create Contract / Service.
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
