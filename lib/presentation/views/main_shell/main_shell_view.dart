import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../getx/main_shell/main_shell_controller.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_bottom_nav.dart';
import '../home/home_view.dart';
import '../messages/messages_view.dart';
import '../profile/profile_view.dart';
import '../projects/projects_view.dart';
import '../services/services_view.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => IndexedStack(
                    index: controller.tabIndex.value,
                    children: const [
                      HomeView(),
                      ServicesView(),
                      MessagesView(),
                      ProjectsView(),
                      ProfileView(),
                    ],
                  ),
                ),
              ),
              const AppBottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}
