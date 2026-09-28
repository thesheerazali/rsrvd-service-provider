import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'translations/ar_sa.dart';
import 'translations/en_us.dart';

/// GetX translation bundle. Strings are looked up with `.tr` /
/// `.trParams({...})` and switch instantly on [Get.updateLocale].
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'ar_SA': arSA,
      };

  static String _localeKey(Locale? locale) {
    if (locale?.languageCode == 'ar') return 'ar_SA';
    return 'en_US';
  }

  /// Direct map lookup — works before [GetMaterialApp] registers `.tr`.
  static String resolve(String key, {Locale? locale}) {
    final bundle = AppTranslations().keys;
    final tag = _localeKey(locale);
    return bundle[tag]?[key] ?? bundle['en_US']?[key] ?? key;
  }

  static String resolveParams(
    String key,
    Map<String, String> params, {
    Locale? locale,
  }) {
    var out = resolve(key, locale: locale);
    for (final e in params.entries) {
      out = out.replaceAll('@${e.key}', e.value);
    }
    return out;
  }
}
