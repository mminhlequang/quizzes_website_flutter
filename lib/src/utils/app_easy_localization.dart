import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

Future initEasyLocalization() async {
  await EasyLocalization.ensureInitialized();
}

Widget wrapEasyLocalization({required child}) => EasyLocalization(
      child: child,
      startLocale: appSupportedLocales.first,
      fallbackLocale: appSupportedLocales.first,
      supportedLocales: appSupportedLocales,
      path: 'assets/l10n',
      assetLoader: const RootBundleAssetLoader(), // default
    );

const List<Locale> appSupportedLocales = [Locale('en'), Locale('fr')];

///////

void setLocale(String? languageCode, {BuildContext? context}) async {
  if (appSupportedLocales.any((e) => e.languageCode == languageCode)) {
    AppPrefs.instance.languageCode = languageCode;
    if (isAppContextReady) {
      var locale =
          appSupportedLocales.firstWhere((e) => e.languageCode == languageCode);
      await (context ?? appContext).setLocale(locale);
      WidgetsFlutterBinding.ensureInitialized().performReassemble();
    }
  }
}

Locale getLocale() {
  if (!AppPrefs.instance.isLanguageCodeEmpty) {
    return _locale(AppPrefs.instance.languageCode);
  }
  final Locale systemLocales = PlatformDispatcher.instance.locale;
  return _locale(systemLocales.languageCode);
}

Locale _locale(String languageCode) {
  if (!appSupportedLocales.any((e) => e.languageCode == languageCode)) {
    return appSupportedLocales.first;
  }
  return Locale(languageCode);
}
