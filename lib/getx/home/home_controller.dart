import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/models/project_item.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';
import '../services/services_controller.dart';

class HomeController extends GetxController {
  HomeController({UserRepository? repository})
      : _users = repository ?? Get.find<UserRepository>();

  final UserRepository _users;

  /// Figma demo atelier until profile edit lands.
  String get businessName =>
      _users.currentUser?.displayName.trim().isNotEmpty == true
          ? _users.currentUser!.displayName
          : 'Marchetti Atelier';

  String get businessSubtitle {
    final occupation = _users.currentUser?.occupation.trim() ?? '';
    if (occupation.isNotEmpty) return occupation;
    return 'Interior Design · Miami';
  }

  String get membershipLabel =>
      _users.currentUser?.membership.homeLabel ?? 'Membership · Yearly';

  String get membershipStatus =>
      _users.currentUser?.membership.statusLabel ?? 'Active';

  String get membershipRenews {
    final label = _users.currentUser?.membership.renewsLabel ?? '';
    return label.isNotEmpty ? label : 'Renews Aug 08, 2027';
  }

  /// Figma `1047:13941` demo stats.
  final newMessages = 3.obs;
  final activeProjects = 4.obs;
  final pendingContracts = 0.obs;
  final completedProjects = 8.obs;

  final averageRating = '4.9'.obs;
  final reviewCount = 3.obs;

  /// Debug: preview populated Home without adding services.
  final debugForcePopulated = false.obs;

  final needsAttention = <ProjectItem>[].obs;

  bool get showDebugToggle => kDebugMode;

  /// Populated Home when partner has services (or debug forces it).
  bool get showPopulated {
    if (debugForcePopulated.value) return true;
    // Resolves lazy ServicesController so Home reacts to catalog changes.
    return Get.find<ServicesController>().services.isNotEmpty;
  }

  String get reviewsLinkLabel =>
      'home_reviews_link'.trParams({'count': '${reviewCount.value}'});

  @override
  void onInit() {
    super.onInit();
    needsAttention.assignAll(_demoNeedsAttention);
  }

  void toggleDebugEmpty() => debugForcePopulated.toggle();

  void onNotifications() => Get.toNamed(AppRoutes.notifications);

  void onManageMembership() => Get.toNamed(AppRoutes.membershipManage);

  void onAddFirstService() => Get.toNamed(AppRoutes.createService);

  void openReviews() => Get.toNamed(AppRoutes.reviews);

  void openProject(ProjectItem item) {
    Get.toNamed(AppRoutes.projectDetail, arguments: {'id': item.id});
  }

  static const _demoNeedsAttention = [
    ProjectItem(
      id: 'attn_indian_creek_active',
      category: 'Interior Design',
      title: 'Indian Creek Residence Design',
      status: 'Active',
      statusTone: ProjectStatusTone.active,
      detail: '',
      stage: ProjectStage.active,
      categoryFilter: 'service_providers',
      counterpartName: 'J. Whitmore',
      amountLabel: r'$150,000',
      metaLine: 'Started Aug 3, 2026 · Updated 1d',
    ),
    ProjectItem(
      id: 'attn_indian_creek_progress',
      category: 'Interior Design',
      title: 'Indian Creek Residence Design',
      status: 'In Progress',
      statusTone: ProjectStatusTone.active,
      detail: '',
      stage: ProjectStage.active,
      categoryFilter: 'service_providers',
      elevated: true,
      counterpartName: 'J. Whitmore',
      amountLabel: r'$150,000',
      metaLine: 'Started Aug 3, 2026 · Updated 1d',
    ),
  ];
}
