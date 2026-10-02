import 'package:get/get.dart';

import '../getx/application_status/application_status_binding.dart';
import '../getx/chat_detail/chat_detail_binding.dart';
import '../getx/create_contract/create_contract_binding.dart';
import '../getx/main_shell/main_shell_binding.dart';
import '../getx/membership/membership_binding.dart';
import '../getx/partner_application/partner_application_binding.dart';
import '../getx/partner_application/partner_application_review_binding.dart';
import '../getx/sign_in/sign_in_binding.dart';
import '../getx/sign_up/sign_up_binding.dart';
import '../getx/splash/splash_binding.dart';
import '../getx/welcome/welcome_binding.dart';
import '../presentation/views/application_status/application_status_view.dart';
import '../presentation/views/chat_detail/chat_detail_view.dart';
import '../presentation/views/create_contract/contract_preview_view.dart';
import '../presentation/views/create_contract/create_contract_view.dart';
import '../presentation/views/main_shell/main_shell_view.dart';
import '../presentation/views/membership/membership_view.dart';
import '../presentation/views/partner_application/partner_application_review_view.dart';
import '../presentation/views/partner_application/partner_application_view.dart';
import '../presentation/views/sign_in/sign_in_view.dart';
import '../presentation/views/sign_up/sign_up_view.dart';
import '../presentation/views/splash/splash_view.dart';
import '../presentation/views/welcome/welcome_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.partnerApplication,
      page: () => const PartnerApplicationView(),
      binding: PartnerApplicationBinding(),
    ),
    GetPage(
      name: AppRoutes.partnerApplicationReview,
      page: () => const PartnerApplicationReviewView(),
      binding: PartnerApplicationReviewBinding(),
    ),
    GetPage(
      name: AppRoutes.applicationStatus,
      page: () => const ApplicationStatusView(),
      binding: ApplicationStatusBinding(),
    ),
    GetPage(
      name: AppRoutes.membership,
      page: () => const MembershipView(),
      binding: MembershipBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainShellView(),
      binding: MainShellBinding(),
    ),
    GetPage(
      name: AppRoutes.chatDetail,
      page: () => const ChatDetailView(),
      binding: ChatDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.createContract,
      page: () => const CreateContractView(),
      binding: CreateContractBinding(),
    ),
    GetPage(
      name: AppRoutes.contractPreview,
      page: () => const ContractPreviewView(),
    ),
  ];
}
