import 'package:get/get.dart';

import '../../data/repositories/user_repository.dart';
import '../../getx/partner_application/partner_application_controller.dart';

/// Settings → Signed NDA — same NDA body + signature block as onboarding.
class SignedNdaController extends GetxController {
  SignedNdaController({UserRepository? userRepository})
      : _users = userRepository ?? Get.find<UserRepository>();

  final UserRepository _users;

  static const String ndaVersion = PartnerApplicationController.ndaVersion;

  String get signedBy {
    final draft = _users.partnerApplication;
    final fromDraft = draft?.contactName.trim() ?? '';
    if (fromDraft.isNotEmpty) return fromDraft;
    final name = _users.currentUser?.displayName.trim() ?? '';
    if (name.isNotEmpty) return name;
    return 'Alexa Miguel';
  }

  String get dateLabel => 'Aug 8, 2026';

  String get timeLabel => '3:28 PM';

  String get versionLabel => ndaVersion;

  void goBack() => Get.back();
}
