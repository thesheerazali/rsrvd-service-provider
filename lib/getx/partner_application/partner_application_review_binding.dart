import 'package:get/get.dart';

import 'partner_application_controller.dart';

/// Review reuses the in-stack [PartnerApplicationController] from the
/// application flow. Rebinds only if the user opened review directly.
class PartnerApplicationReviewBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PartnerApplicationController>()) {
      Get.lazyPut(PartnerApplicationController.new);
    }
  }
}
