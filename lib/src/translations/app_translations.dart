import 'package:get/get.dart';

import '../../main.dart';
import '../utils/utils.dart';
import 'fr_fr_translation.dart';
import 'en_us_translations.dart';
import 'dart:ui';

//===== INPUT IN MAIN FILE
//
// static void setLocale(BuildContext context, Locale newLocale) {
//   _AppState state = context.findAncestorStateOfType<_AppState>()!;
//   state.setLocale(newLocale);
// }
//
// Locale? _locale;
// setLocale(Locale locale) {
//   setState(() {
//     _locale = locale;
//   });
// }

// @override
// void didChangeDependencies() async {
//   setState(() {
//     this._locale = getLocale();
//   });
//   super.didChangeDependencies();
// }

//languages code
const String english = 'en';
const String french = 'fr';

List languagelist = [
  english,
  french,
];

List<Locale> supportedlocale = [
  const Locale(english, "US"),
  const Locale(french, 'FR'),
];

void setLocale(languageCode) {
  if (supportedlocale.any((e) => e.languageCode == languageCode)) {
    AppPrefs.instance.languageCode = languageCode;
    Get.locale =
        supportedlocale.firstWhere((e) => e.languageCode == languageCode);
    App.setLocale(Get.context!,
        supportedlocale.firstWhere((e) => e.languageCode == languageCode));
  }
}

Locale getLocale() {
  if (AppPrefs.instance.languageCode != null)
    return _locale(AppPrefs.instance.languageCode!);
  final Locale systemLocales = window.locale;
  return _locale(systemLocales.languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case french:
      return const Locale(french, 'FR');
    case english:
      return const Locale(english, 'US');
    default:
      return const Locale(english, 'US');
  }
}

abstract class AppTranslation {
  static Map<String, Map<String, String>> translations = {
    'en_US': enUs,
    'fr_FR': frFR
  };
}
