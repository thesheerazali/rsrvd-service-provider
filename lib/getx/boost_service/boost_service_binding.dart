import 'package:get/get.dart';

import 'boost_service_controller.dart';

class BoostServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoostServiceController>(() => BoostServiceController());
  }
}
