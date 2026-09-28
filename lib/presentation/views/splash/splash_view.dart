import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/extensions/extensions.dart';
import '../../../getx/splash/splash_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/brand_logo.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.hero,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.dw(48)),
              child: const BrandLogoSplash(),
            ),
          ),
        ),
      ),
    );
  }
}
