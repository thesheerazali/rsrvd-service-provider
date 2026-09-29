import 'package:get/get.dart';

import '../home/home_controller.dart';
import 'main_shell_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(MainShellController.new);
    Get.lazyPut(HomeController.new);
  }
}
