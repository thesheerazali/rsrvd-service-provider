import 'package:get/get.dart';

import '../../core/debug/app_boot.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final UserRepository _users = Get.find<UserRepository>();

  @override
  void onInit() {
    super.onInit();
    _boot();
  }

  Future<void> _boot() async {
    final delay = Future<void>.delayed(const Duration(seconds: 2));
    await _users.hydrateSession();
    await delay;

    final route = switch (AppBoot.splashTarget) {
      BootTarget.welcome => AppRoutes.welcome,
      BootTarget.home => AppRoutes.home,
      BootTarget.session => _users.continueRoute,
    };
    AppLog.i(
      'Splash → $route (boot=${AppBoot.splashTarget.name})',
      tag: 'SPLASH',
    );
    Get.offAllNamed(route);
  }
}
