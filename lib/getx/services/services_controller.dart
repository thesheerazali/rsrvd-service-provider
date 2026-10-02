import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/models/app_filter_config.dart';
import '../../core/models/partner_service.dart';
import '../../core/services/app_flash.dart';
import '../../presentation/widgets/app_confirm_dialog.dart';
import '../../presentation/widgets/app_filter_dialog.dart';
import '../../routes/app_routes.dart';

/// My Services tab — Figma `1196:1490`.
class ServicesController extends GetxController {
  final debugShowEmpty = false.obs;
  final services = <PartnerService>[].obs;
  final filterSelection = Rxn<AppFilterSelection>();

  bool get showDebugToggle => kDebugMode;

  bool get showEmpty => debugShowEmpty.value || services.isEmpty;

  List<PartnerService> get visibleServices {
    final sel = filterSelection.value;
    var list = services.toList();
    if (sel != null) {
      final status = sel['status'] ?? {};
      if (status.isNotEmpty && !status.contains('all')) {
        list = list.where((s) {
          if (status.contains('approved') &&
              s.reviewStatus == PartnerServiceReviewStatus.approved) {
            return true;
          }
          if (status.contains('pending') &&
              s.reviewStatus == PartnerServiceReviewStatus.pending) {
            return true;
          }
          if (status.contains('rejected') &&
              s.reviewStatus == PartnerServiceReviewStatus.rejected) {
            return true;
          }
          return false;
        }).toList();
      }
      final sort = sel['sort'] ?? {};
      if (sort.contains('boosted')) {
        list.sort((a, b) {
          if (a.isBoosted == b.isBoosted) return 0;
          return a.isBoosted ? -1 : 1;
        });
      }
    }
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    services.assignAll(_demoServices);
  }

  void toggleDebugEmpty() => debugShowEmpty.toggle();

  void onAddService() => Get.toNamed(AppRoutes.createService);

  Future<void> onFilterTap() async {
    final result = await AppFilterDialog.show(
      config: AppFilterConfig.partnersServices,
      initial: filterSelection.value,
    );
    if (result != null) {
      filterSelection.value = result;
    }
  }

  void onEditService(PartnerService service) {
    Get.toNamed(
      AppRoutes.createService,
      arguments: {'service_id': service.id},
    );
  }

  Future<void> onDeleteService(PartnerService service) async {
    final confirmed = await AppConfirmDialog.show(
      eyebrow: 'Delete',
      title: 'Delete this service?',
      message:
          '“${service.title}” will be removed from your catalog. This can’t be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
    );
    if (confirmed != true) return;
    services.removeWhere((s) => s.id == service.id);
    AppFlash.success('Service deleted');
  }

  void onBoostService(PartnerService service) {
    Get.toNamed(
      AppRoutes.boostService,
      arguments: {'service_id': service.id},
    );
  }

  void applyBoost(String serviceId) {
    final i = services.indexWhere((s) => s.id == serviceId);
    if (i < 0) return;
    services[i] = services[i].copyWith(isBoosted: true);
  }

  void addService(PartnerService service) {
    services.insert(0, service);
  }

  void upsertService(PartnerService service) {
    final i = services.indexWhere((s) => s.id == service.id);
    if (i < 0) {
      services.insert(0, service);
    } else {
      services[i] = service;
    }
  }

  void openServiceStatus(PartnerService service) {
    Get.toNamed(AppRoutes.serviceReviewStatus, arguments: service.id);
  }

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
      reviewStatus: PartnerServiceReviewStatus.approved,
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
      reviewStatus: PartnerServiceReviewStatus.approved,
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
      reviewStatus: PartnerServiceReviewStatus.approved,
    ),
  ];
}
