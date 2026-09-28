import 'package:get/get.dart';

import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  HomeController({UserRepository? repository})
      : _users = repository ?? Get.find<UserRepository>();

  final UserRepository _users;

  String get displayName => _users.currentUser?.displayName ?? 'Provider';

  String get providerId => _users.currentUser?.providerId ?? '';

  Future<void> signOut() async {
    await _users.signOut();
    Get.offAllNamed(AppRoutes.welcome);
  }
}
