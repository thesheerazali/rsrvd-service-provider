import 'package:get/get.dart';

import 'reviews_controller.dart';

class ReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ReviewsController.new);
  }
}
