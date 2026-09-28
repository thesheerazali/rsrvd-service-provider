import 'dart:ui';

import 'package:get/get.dart';

import '../services/storage_service.dart';
import 'app_translations.dart';

/// Manages the app locale (English / Arabic) with persistence.
///
/// RTL layout for Arabic is automatic: GetMaterialApp derives text direction
/// from the active locale.
class LocalizationService extends GetxService {
  static const Locale english = Locale('en', 'US');
  static const Locale arabic = Locale('ar', 'SA');

  static const Locale fallbackLocale = english;
  static const List<Locale> supportedLocales = [english, arabic];

  final StorageService _storage = Get.find<StorageService>();

  /// Locale to boot the app with — persisted choice, else device language
  /// when supported, else English.
  Locale get initialLocale {
    final saved = _storage.languageCode;
    if (saved != null) return _localeFromCode(saved);

    final device = Get.deviceLocale;
    if (device != null && device.languageCode == 'ar') return arabic;
    return english;
  }

  bool get isArabic => Get.locale?.languageCode == 'ar';

  Locale get effectiveLocale => Get.locale ?? initialLocale;

  String translate(String key) =>
      AppTranslations.resolve(key, locale: effectiveLocale);

  String translateParams(String key, Map<String, String> params) =>
      AppTranslations.resolveParams(key, params, locale: effectiveLocale);

  void changeLanguage(String languageCode) {
    final locale = _localeFromCode(languageCode);
    _storage.languageCode = locale.languageCode;
    Get.updateLocale(locale);
  }

  void toggleLanguage() => changeLanguage(isArabic ? 'en' : 'ar');

  Locale _localeFromCode(String code) => code == 'ar' ? arabic : english;
}
