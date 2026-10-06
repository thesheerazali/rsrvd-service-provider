import 'package:get/get.dart';

import '../getx/application_status/application_status_binding.dart';
import '../getx/chat_detail/chat_detail_binding.dart';
import '../getx/create_contract/create_contract_binding.dart';
import '../getx/boost_service/boost_service_binding.dart';
import '../getx/create_service/create_service_binding.dart';
import '../getx/main_shell/main_shell_binding.dart';
import '../getx/membership/membership_binding.dart';
import '../getx/membership/membership_manage_binding.dart';
import '../getx/partner_application/partner_application_binding.dart';
import '../getx/partner_application/partner_application_review_binding.dart';
import '../getx/documents/documents_binding.dart';
import '../getx/edit_profile/edit_profile_binding.dart';
import '../getx/help_support/help_support_binding.dart';
import '../getx/notifications/notifications_binding.dart';
import '../getx/partner_terms/partner_terms_binding.dart';
import '../getx/privacy_policy/privacy_policy_binding.dart';
import '../getx/project_detail/project_detail_binding.dart';
import '../getx/reviews/reviews_binding.dart';
import '../getx/service_review_status/service_review_status_binding.dart';
import '../getx/settings/settings_binding.dart';
import '../getx/sign_in/sign_in_binding.dart';
import '../getx/sign_up/sign_up_binding.dart';
import '../getx/signed_nda/signed_nda_binding.dart';
import '../getx/splash/splash_binding.dart';
import '../getx/update_password/update_password_binding.dart';
import '../getx/welcome/welcome_binding.dart';
import '../presentation/views/application_status/application_status_view.dart';
import '../presentation/views/boost_service/boost_service_view.dart';
import '../presentation/views/chat_detail/chat_detail_view.dart';
import '../presentation/views/create_contract/contract_preview_view.dart';
import '../presentation/views/create_contract/create_contract_view.dart';
import '../presentation/views/create_service/create_service_view.dart';
import '../presentation/views/documents/documents_view.dart';
import '../presentation/views/edit_profile/edit_profile_view.dart';
import '../presentation/views/help_support/help_support_view.dart';
import '../presentation/views/main_shell/main_shell_view.dart';
import '../presentation/views/membership/membership_manage_view.dart';
import '../presentation/views/membership/membership_view.dart';
import '../presentation/views/notifications/notifications_view.dart';
import '../presentation/views/partner_application/partner_application_review_view.dart';
import '../presentation/views/reviews/reviews_view.dart';
import '../presentation/views/partner_application/partner_application_view.dart';
import '../presentation/views/partner_terms/partner_terms_view.dart';
import '../presentation/views/privacy_policy/privacy_policy_view.dart';
import '../presentation/views/project_detail/project_detail_view.dart';
import '../presentation/views/service_review_status/service_review_status_view.dart';
import '../presentation/views/settings/settings_view.dart';
import '../presentation/views/sign_in/sign_in_view.dart';
import '../presentation/views/sign_up/sign_up_view.dart';
import '../presentation/views/signed_nda/signed_nda_view.dart';
import '../presentation/views/splash/splash_view.dart';
import '../presentation/views/update_password/update_password_view.dart';
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
      name: AppRoutes.membershipManage,
      page: () => const MembershipManageView(),
      binding: MembershipManageBinding(),
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
    GetPage(
      name: AppRoutes.createService,
      page: () => const CreateServiceView(),
      binding: CreateServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.serviceReviewStatus,
      page: () => const ServiceReviewStatusView(),
      binding: ServiceReviewStatusBinding(),
    ),
    GetPage(
      name: AppRoutes.boostService,
      page: () => const BoostServiceView(),
      binding: BoostServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.projectDetail,
      page: () => const ProjectDetailView(),
      binding: ProjectDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.reviews,
      page: () => const ReviewsView(),
      binding: ReviewsBinding(),
    ),
    GetPage(
      name: AppRoutes.updatePassword,
      page: () => const UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: AppRoutes.helpSupport,
      page: () => const HelpSupportView(),
      binding: HelpSupportBinding(),
    ),
    GetPage(
      name: AppRoutes.signedNda,
      page: () => const SignedNdaView(),
      binding: SignedNdaBinding(),
    ),
    GetPage(
      name: AppRoutes.documents,
      page: () => const DocumentsView(),
      binding: DocumentsBinding(),
    ),
    GetPage(
      name: AppRoutes.partnerTerms,
      page: () => const PartnerTermsView(),
      binding: PartnerTermsBinding(),
    ),
  ];
}
