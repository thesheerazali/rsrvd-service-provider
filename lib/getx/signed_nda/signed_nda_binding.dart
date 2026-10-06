import 'package:get/get.dart';

import 'signed_nda_controller.dart';

class SignedNdaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(SignedNdaController.new);
  }
}
