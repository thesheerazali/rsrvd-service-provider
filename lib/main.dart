import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:rsrvd_service_provider/app.dart';
import 'package:rsrvd_service_provider/core/localization/localization_service.dart';
import 'package:rsrvd_service_provider/core/services/storage_service.dart';
import 'package:rsrvd_service_provider/data/repositories/membership_repository.dart';
import 'package:rsrvd_service_provider/data/repositories/messages_repository.dart';
import 'package:rsrvd_service_provider/data/repositories/profile_repository.dart';
import 'package:rsrvd_service_provider/data/repositories/projects_repository.dart';
import 'package:rsrvd_service_provider/data/repositories/reviews_repository.dart';
import 'package:rsrvd_service_provider/data/repositories/settings_repository.dart';
import 'package:rsrvd_service_provider/data/repositories/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local storage must be ready before any screen reads from it.
  await StorageService.init();
  Get.put(StorageService(), permanent: true);
  Get.put(UserRepository(), permanent: true);
  Get.put(MembershipRepository(), permanent: true);
  Get.put(MessagesRepository(), permanent: true);
  Get.put(ProjectsRepository(), permanent: true);
  Get.put(ProfileRepository(), permanent: true);
  Get.put(ReviewsRepository(), permanent: true);
  Get.put(SettingsRepository(), permanent: true);
  Get.put(LocalizationService(), permanent: true);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // dark-first UI
    ),
  );
  runApp(const RsrvdServiceProviderApp());
}
