import 'package:get/get.dart';

import '../../core/services/app_log.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final UserRepository _repository = Get.find<UserRepository>();

  @override
  void onInit() {
    super.onInit();
    _boot();
  }

  Future<void> _boot() async {
    final delay = Future<void>.delayed(const Duration(seconds: 2));
    await _repository.hydrateSession();
    await delay;
    final route = _repository.isSignedIn
        ? AppRoutes.home
        : AppRoutes.welcome;
    AppLog.i('Splash → $route', tag: 'SPLASH');
    Get.offAllNamed(route);
  }
}
