import 'package:get/get.dart';

import '../getx/main_shell/main_shell_binding.dart';
import '../getx/sign_in/sign_in_binding.dart';
import '../getx/sign_up/sign_up_binding.dart';
import '../getx/splash/splash_binding.dart';
import '../getx/welcome/welcome_binding.dart';
import '../presentation/views/main_shell/main_shell_view.dart';
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
      name: AppRoutes.home,
      page: () => const MainShellView(),
      binding: MainShellBinding(),
    ),
  ];
}
