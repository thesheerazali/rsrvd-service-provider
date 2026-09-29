import 'package:get/get.dart';

enum MainTab { home, services, chats, projects, profile }

class MainShellController extends GetxController {
  final tabIndex = 0.obs;

  MainTab get currentTab => MainTab.values[tabIndex.value];

  void selectTab(int index) {
    if (index < 0 || index >= MainTab.values.length) return;
    tabIndex.value = index;
  }
}
