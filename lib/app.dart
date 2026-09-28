import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'package:rsrvd_service_provider/core/localization/app_translations.dart';
import 'package:rsrvd_service_provider/core/localization/localization_service.dart';
import 'package:rsrvd_service_provider/core/services/route_logger.dart';
import 'package:rsrvd_service_provider/core/themes/light_theme.dart';
import 'package:rsrvd_service_provider/routes/app_pages.dart';
import 'package:rsrvd_service_provider/routes/app_routes.dart';

class RsrvdServiceProviderApp extends StatelessWidget {
  const RsrvdServiceProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<LocalizationService>();

    return GetMaterialApp(
      title: 'RSRVD Provider',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      translations: AppTranslations(),
      locale: localization.initialLocale,
      fallbackLocale: LocalizationService.fallbackLocale,
      supportedLocales: LocalizationService.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorObservers: [RouteLogger()],
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
