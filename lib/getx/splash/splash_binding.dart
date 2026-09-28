import 'package:get/get.dart';

import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Eager put: splash view is visual-only; navigation is driven from onInit.
    Get.put(SplashController());
  }
}
