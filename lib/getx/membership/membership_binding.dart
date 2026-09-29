import 'package:get/get.dart';

import 'membership_controller.dart';

class MembershipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MembershipController>(() => MembershipController());
  }
}
