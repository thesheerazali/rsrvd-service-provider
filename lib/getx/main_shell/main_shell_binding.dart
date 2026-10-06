import 'package:get/get.dart';

import '../home/home_controller.dart';
import '../messages/messages_controller.dart';
import '../projects/projects_controller.dart';
import '../services/services_controller.dart';
import 'main_shell_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(MainShellController.new);
    Get.lazyPut(HomeController.new);
    Get.lazyPut(ServicesController.new);
    Get.lazyPut(MessagesController.new);
    Get.lazyPut(ProjectsController.new);
  }
}
