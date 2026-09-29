import 'package:get/get.dart';

import 'home_controller.dart';

/// Prefer [MainShellBinding] — kept for isolated home tests.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(HomeController.new);
  }
}
