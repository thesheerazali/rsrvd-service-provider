import 'package:get/get.dart';

import 'application_status_controller.dart';

class ApplicationStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationStatusController>(
      () => ApplicationStatusController(),
    );
  }
}
