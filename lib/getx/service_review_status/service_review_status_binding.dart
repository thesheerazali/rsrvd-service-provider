import 'package:get/get.dart';

import 'service_review_status_controller.dart';

class ServiceReviewStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceReviewStatusController>(
      () => ServiceReviewStatusController(),
    );
  }
}
