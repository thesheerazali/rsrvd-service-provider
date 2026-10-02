import 'package:get/get.dart';

import 'create_contract_controller.dart';

class CreateContractBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateContractController>(() => CreateContractController());
  }
}
