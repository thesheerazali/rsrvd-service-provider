import 'package:get/get.dart';

import 'id_verification_controller.dart';

class IdVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(IdVerificationController.new);
  }
}
