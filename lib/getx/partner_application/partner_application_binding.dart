import 'package:get/get.dart';

import 'partner_application_controller.dart';

class PartnerApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(PartnerApplicationController.new);
  }
}
