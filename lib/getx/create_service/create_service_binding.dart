import 'package:get/get.dart';

import 'create_service_controller.dart';

class CreateServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateServiceController>(() => CreateServiceController());
  }
}
