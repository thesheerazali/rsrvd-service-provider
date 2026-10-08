import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_images.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/partner_application/partner_application_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_nda_card.dart';
import '../../widgets/app_removable_chip.dart';
import '../../widgets/app_select_chip.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_uploaded_doc_card.dart';
import '../../widgets/primary_button.dart';

abstract class _FieldInput {
  static final textOnly = [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s\-']")),
  ];
  static final phone = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-()]')),
  ];
  static final digitsOnly = [FilteringTextInputFormatter.digitsOnly];
}

/// Partner Application — 4 steps (Figma `1196:232`+).
class PartnerApplicationView extends GetView<PartnerApplicationController> {
  const PartnerApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.auth,
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              const _Header(),
              Expanded(
                child: Obx(() {
                  final step = controller.currentStep.value;
                  return ListView(
                    padding: EdgeInsets.fromLTRB(
                      context.dw(AppSpacing.t30),
                      context.dw(AppSpacing.t20),
                      context.dw(AppSpacing.t30),
                      context.dw(AppSpacing.t40),
                    ),
                    children: [
                      Text(
                        controller.stepTitle.toUpperCase(),
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.w700,
                          fontSize: context.dw(24),
                          height: 1.2,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      _StepProgress(
                        currentStep: step,
                        totalSteps: PartnerApplicationController.totalSteps,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      if (step == 0)
                        const _Step1BasicInfo()
                      else if (step == 1)
                        const _Step2Categories()
                      else if (step == 2)
                        const _Step3Documents()
                      else
                        const _Step4Nda(),
                      SizedBox(height: context.dw(AppSpacing.t30)),
                      PrimaryButton(
                        label: 'continue'.tr,
                        enabled: !controller.isSubmitting.value,
                        onPressed: controller.onPrimaryCta,
                      ),
                      SizedBox(height: context.dw(AppSpacing.t10)),
                      Center(
                        child: GestureDetector(
                          onTap: controller.goBack,
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            'go_back'.tr,
                            style: GoogleFonts.darkerGrotesque(
                              fontWeight: FontWeight.w600,
                              fontSize: context.dw(24),
                              height: 1.2,
                              color: AppColors.primary.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends GetView<PartnerApplicationController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceCard, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t10),
        context.dw(AppSpacing.t30),
        context.dw(AppSpacing.t16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: controller.goBack,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.only(top: context.dw(AppSpacing.t08)),
              child: SvgPicture.asset(
                AppIcons.iconArrowLeft,
                width: context.dw(24),
                height: context.dw(24),
                colorFilter: ColorFilter.mode(
                  AppColors.text.withValues(alpha: 0.8),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: context.dw(AppSpacing.t10)),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PartnerApplicationController.screenTitle,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w600,
                      fontSize: context.dw(24),
                      height: 1.2,
                      color: AppColors.text.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    controller.headerSubtitle,
                    style: GoogleFonts.darkerGrotesque(
                      fontWeight: FontWeight.w500,
                      fontSize: context.dw(18),
                      height: 1.2,
                      color: AppColors.text.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < totalSteps; i++) ...[
         // if (i > 0) SizedBox(width: context.dw(AppSpacing.t04)),
          Expanded(
            child: Container(
              height: context.dw(3),
              color: i <= currentStep
                  ? AppColors.primary
                  : AppColors.surfaceCard,
            ),
          ),
        ],
      ],
    );
  }
}

/// Step 1 — Basic Information (Figma `1196:232`).
class _Step1BasicInfo extends GetView<PartnerApplicationController> {
  const _Step1BasicInfo();

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'pa_contact_name'.tr,
          hint: 'Alixa Miguel',
          controller: controller.contactNameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          inputFormatters: _FieldInput.textOnly,
        ),
        SizedBox(height: context.dw(AppSpacing.t20)),
        AppTextField(
          label: 'pa_phone'.tr,
          hint: '+1 234 567 890',
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          inputFormatters: _FieldInput.phone,
        ),
        SizedBox(height: context.dw(AppSpacing.t20)),
        AppTextField(
          label: 'pa_business_name'.tr,
          hint: 'Zavier Groups',
          controller: controller.businessNameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: context.dw(AppSpacing.t20)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                label: 'pa_city'.tr,
                hint: 'Zurich',
                controller: controller.cityController,
                textInputAction: TextInputAction.next,
                inputFormatters: _FieldInput.textOnly,
              ),
            ),
            SizedBox(width: context.dw(AppSpacing.t20)),
            Expanded(
              child: AppTextField(
                label: 'pa_state'.tr,
                hint: 'north-central',
                controller: controller.stateController,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
        SizedBox(height: context.dw(AppSpacing.t20)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                label: 'pa_country'.tr,
                hint: 'Switzerland',
                controller: controller.countryController,
                textInputAction: TextInputAction.next,
                inputFormatters: _FieldInput.textOnly,
              ),
            ),
            SizedBox(width: context.dw(AppSpacing.t20)),
            Expanded(
              child: AppTextField(
                label: 'pa_experience'.tr,
                hint: '08',
                controller: controller.experienceController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: _FieldInput.digitsOnly,
              ),
            ),
          ],
        ),
        SizedBox(height: context.dw(AppSpacing.t20)),
        Text('pa_bio'.tr, style: labelStyle),
        SizedBox(height: context.dw(AppSpacing.t08)),
        TextField(
          controller: controller.bioController,
          minLines: 3,
          maxLines: 5,
          style: fieldStyle,
          cursorColor: AppColors.primary,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintText: 'pa_bio_hint'.tr,
            hintStyle: hintStyle,
            filled: false,
            contentPadding: EdgeInsets.all(context.dw(AppSpacing.t20)),
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
        ),
        SizedBox(height: context.dw(AppSpacing.t20)),
        AppTextField(
          label: 'pa_expertise'.tr,
          hint: 'pa_expertise_hint'.tr,
          controller: controller.expertiseInputController,
          textInputAction: TextInputAction.done,
          onSubmitted: controller.addExpertise,
        ),
        SizedBox(height: context.dw(AppSpacing.t08)),
        Obx(
          () => AppRemovableChipWrap(
            values: controller.expertise.toList(),
            onRemove: controller.removeExpertise,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t20)),
        AppTextField(
          label: 'pa_service_areas'.tr,
          hint: 'pa_service_areas_hint'.tr,
          controller: controller.serviceAreaInputController,
          textInputAction: TextInputAction.done,
          onSubmitted: controller.addServiceArea,
        ),
        SizedBox(height: context.dw(AppSpacing.t08)),
        Obx(
          () => AppRemovableChipWrap(
            values: controller.serviceAreas.toList(),
            onRemove: controller.removeServiceArea,
          ),
        ),
      ],
    );
  }
}

/// Step 2 — Service Categories.
class _Step2Categories extends GetView<PartnerApplicationController> {
  const _Step2Categories();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'pa_select_category_label'.tr,
          style: GoogleFonts.darkerGrotesque(
            fontWeight: FontWeight.w500,
            fontSize: context.dw(20),
            height: 1.2,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t16)),
        Obx(
          () => AppSelectChipWrap(
            items: PartnerApplicationController.serviceCategories,
            selectedIds: controller.selectedCategoryIds.toSet(),
            onSelected: controller.toggleCategory,
          ),
        ),
      ],
    );
  }
}

/// Step 3 — Verification & Documents.
class _Step3Documents extends GetView<PartnerApplicationController> {
  const _Step3Documents();

  static const _uploadOptions = [
    'pa_doc_gov_id',
    'pa_doc_driving',
    'pa_doc_business',
  ];

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.darkerGrotesque(
      fontWeight: FontWeight.w500,
      fontSize: context.dw(20),
      height: 1.2,
      color: AppColors.text,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t20), vertical: context.dw(AppSpacing.t10)),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
          //  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
          ),
          child: Text(
            'pa_docs_notice'.tr,
            style: GoogleFonts.darkerGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: context.dw(16),
              height: 1,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t24)),
        Text('pa_upload_documents'.tr, style: labelStyle),
        SizedBox(height: context.dw(AppSpacing.t12)),
        Row(
          children: [
            Expanded(
              child: _UploadTile(
                label: _uploadOptions[0].tr,
                onTap: () => controller.addDemoDocument(_uploadOptions[0]),
              ),
            ),
            SizedBox(width: context.dw(AppSpacing.t12)),
            Expanded(
              child: _UploadTile(
                label: _uploadOptions[1].tr,
                onTap: () => controller.addDemoDocument(_uploadOptions[1]),
              ),
            ),
          ],
        ),
        SizedBox(height: context.dw(AppSpacing.t12)),
        _UploadTile(
          label: _uploadOptions[2].tr,
          onTap: () => controller.addDemoDocument(_uploadOptions[2]),
        ),
        SizedBox(height: context.dw(AppSpacing.t24)),
        Obx(
          () => Text(
            'pa_uploaded_count'.trParams({
              'count': '${controller.documents.length}',
            }),
            style: labelStyle,
          ),
        ),
        SizedBox(height: context.dw(AppSpacing.t12)),
        Obx(
          () => Column(
            children: [
              for (var i = 0; i < controller.documents.length; i++) ...[
                if (i > 0) SizedBox(height: context.dw(AppSpacing.t12)),
                AppUploadedDocCard(
                  iconColor: AppColors.text.withValues(alpha: 0.5),
                  textColor: AppColors.primary,
                  document: controller.documents[i],
                  onRetry: () =>
                      controller.retryDocument(controller.documents[i].id),
                  onDelete: () =>
                      controller.removeDocument(controller.documents[i].id),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.dw(50),
        padding: EdgeInsets.symmetric(horizontal: context.dw(AppSpacing.t16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.dw(AppSpacing.radiusSm)),
          border: Border.all(color: AppColors.surfaceCard),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              AppIcons.iconUpload,
              width: context.dw(18),
              height: context.dw(18),
              colorFilter: const ColorFilter.mode(
                AppColors.text,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: context.dw(AppSpacing.t08)),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.darkerGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: context.dw(18),
                  height: 1.2,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Step 4 — RSRVD Partner NDA.
class _Step4Nda extends GetView<PartnerApplicationController> {
  const _Step4Nda();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppNdaBodyCard(),
        SizedBox(height: context.dw(AppSpacing.t24)),
        GestureDetector(
          onTap: controller.toggleNda,
          behavior: HitTestBehavior.opaque,
          child: Obx(
            () {
              final accepted = controller.ndaAccepted.value;
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: context.dw(AppSpacing.t16),
                  vertical: context.dw(AppSpacing.t10),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    context.dw(AppSpacing.radiusSm),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: context.dw(14),
                      height: context.dw(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        color: accepted
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                      child: accepted
                          ? Icon(
                              Icons.check,
                              size: context.dw(8),
                              color: AppColors.white,
                            )
                          : null,
                    ),
                    SizedBox(width: context.dw(AppSpacing.t10)),
                    Expanded(
                      child: Text(
                        'pa_nda_agree'.tr,
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(16),
                          height: 1,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Obx(() {
          if (!controller.ndaAccepted.value) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              SizedBox(height: context.dw(AppSpacing.t12)),
              AppNdaSignatureDetails(
                signedBy: controller.ndaSignedBy,
                date: controller.ndaSignedDateLabel,
                time: controller.ndaSignedTimeLabel,
                version: PartnerApplicationController.ndaVersion,
              ),
            ],
          );
        }),
      ],
    );
  }
}

