import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/models/partner_service.dart';
import '../../core/services/app_flash.dart';

/// My Services tab — Figma `1196:1490`.
///
/// Starts with demo cards; debug toggle (kDebugMode) flips empty state for QA.
class ServicesController extends GetxController {
  /// QA-only: when true, show [EmptyServicesBlock] instead of cards.
  final debugShowEmpty = false.obs;

  final services = <PartnerService>[].obs;

  bool get showDebugToggle => kDebugMode;

  bool get showEmpty =>
      debugShowEmpty.value || services.isEmpty;

  @override
  void onInit() {
    super.onInit();
    services.assignAll(_demoServices);
  }

  void toggleDebugEmpty() => debugShowEmpty.toggle();

  void onAddService() => AppFlash.info('coming_soon'.tr);

  void onEditService(PartnerService service) =>
      AppFlash.info('coming_soon'.tr);

  void onDeleteService(PartnerService service) =>
      AppFlash.info('coming_soon'.tr);

  void onBoostService(PartnerService service) {
    final i = services.indexWhere((s) => s.id == service.id);
    if (i < 0) return;
    services[i] = service.copyWith(isBoosted: true);
    AppFlash.info('coming_soon'.tr);
  }

  /// Figma `1196:1524`–`1573` demo catalog.
  static const _demoServices = [
    PartnerService(
      id: 'svc_architect_full',
      title: 'Full Architect Design',
      category: 'Architect',
      description:
          'Concept through installation for primary and secondary residences.',
      priceLabel: r'$150,000 · Starting From',
      isPublished: true,
      isBoosted: true,
    ),
    PartnerService(
      id: 'svc_planning',
      title: 'Planning and Design',
      category: 'Architect',
      description:
          'Creating functional and aesthetically pleasing interiors for '
          'residential and commercial spaces.',
      priceLabel: r'$150,000 · Starting From',
      isPublished: true,
    ),
    PartnerService(
      id: 'svc_outdoor',
      title: 'Outdoor Space REDesign',
      category: 'Architect',
      description:
          'Designing sustainable and engaging outdoor environments for '
          'public and private properties.',
      priceLabel: r'$150,000 · Starting From',
      isPublished: true,
    ),
  ];
}
