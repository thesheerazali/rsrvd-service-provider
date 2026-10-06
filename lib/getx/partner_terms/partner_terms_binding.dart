import 'package:get/get.dart';

import 'partner_terms_controller.dart';

class PartnerTermsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(PartnerTermsController.new);
  }
}
