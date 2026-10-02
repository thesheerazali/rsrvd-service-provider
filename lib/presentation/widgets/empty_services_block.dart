import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/styles/app_images.dart';
import 'app_empty_state.dart';

/// Empty services block — Home + My Services (Figma empty / debug).
class EmptyServicesBlock extends StatelessWidget {
  const EmptyServicesBlock({
    super.key,
    required this.onAddPressed,
  });

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      imageAsset: AppImages.emptyService,
      title: 'empty_services_title'.tr,
      body: 'empty_services_body'.tr,
      ctaLabel: 'empty_services_cta'.tr,
      onCtaPressed: onAddPressed,
    );
  }
}
