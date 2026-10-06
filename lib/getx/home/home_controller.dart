import 'package:get/get.dart';

import '../../core/services/app_flash.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';
import '../main_shell/main_shell_controller.dart';

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

  final newMessages = 0.obs;
  final activeProjects = 0.obs;
  final pendingContracts = 0.obs;
  final completedProjects = 0.obs;

  bool get hasServices => false;

  void onNotifications() => AppFlash.info('coming_soon'.tr);

  void onManageMembership() => Get.toNamed(AppRoutes.membershipManage);

  void onAddFirstService() {
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().selectTab(MainTab.services.index);
    }
    AppFlash.info('coming_soon'.tr);
  }
}
