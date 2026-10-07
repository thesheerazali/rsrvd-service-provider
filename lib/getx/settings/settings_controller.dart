import 'package:get/get.dart';

import '../../core/styles/app_colors.dart';
import '../../data/repositories/user_repository.dart';
import '../../presentation/widgets/app_confirm_dialog.dart';
import '../../routes/app_routes.dart';

class SettingsController extends GetxController {
  SettingsController({UserRepository? userRepository})
      : _userRepository = userRepository ?? Get.find<UserRepository>();

  final UserRepository _userRepository;

  void goBack() => Get.back();

  void openEditProfile() => Get.toNamed(AppRoutes.editProfile);

  void openNotifications() => Get.toNamed(AppRoutes.notifications);

  void openMembership() => Get.toNamed(AppRoutes.membershipManage);

  void openReviews() => Get.toNamed(AppRoutes.reviews);

  void openSignedNda() => Get.toNamed(AppRoutes.signedNda);

  void openDocuments() => Get.toNamed(AppRoutes.documents);

  void openHelp() => Get.toNamed(AppRoutes.helpSupport);

  void openPartnerTerms() => Get.toNamed(AppRoutes.partnerTerms);

  void openPrivacy() => Get.toNamed(AppRoutes.privacyPolicy);

  void openChangePassword() => Get.toNamed(
        AppRoutes.updatePassword,
        arguments: {'mode': 'settings'},
      );

  Future<void> logout() async {
    final confirmed = await AppConfirmDialog.show(
      eyebrow: 'Account',
      title: 'Log out?',
      message:
          'You will need to sign in again to access your RSRVD Partner account.',
      confirmLabel: 'Logout',
      cancelLabel: 'Cancel',
    );
    if (confirmed != true) return;
    await _userRepository.signOut();
    Get.offAllNamed(AppRoutes.welcome);
  }

  Future<void> deleteAccount() async {
    final confirmed = await AppConfirmDialog.show(
      eyebrow: 'Confirm',
      title: 'Are You Sure You Want To Delete This Account?',
      message: 'This action can not be undone.',
      confirmLabel: 'Yes, Delete',
      cancelLabel: 'Cancel',
      confirmColor: AppColors.error,
      cancelColor: AppColors.error,
    );
    if (confirmed != true) return;
    await _userRepository.signOut();
    Get.offAllNamed(AppRoutes.welcome);
  }
}
