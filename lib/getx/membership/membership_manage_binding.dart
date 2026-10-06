import 'package:get/get.dart';

import 'membership_manage_controller.dart';

class MembershipManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(MembershipManageController.new);
  }
}
