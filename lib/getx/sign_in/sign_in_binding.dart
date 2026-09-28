import 'package:get/get.dart';

import 'sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent: `offAllNamed(signIn)` removes older `/sign_in` routes after
    // pushing the new one. Non-permanent registration gets deleted with those
    // old routes — disposing TextEditingControllers the new page still uses.
    if (!Get.isRegistered<SignInController>()) {
      Get.put(SignInController(), permanent: true);
    }
  }
}
