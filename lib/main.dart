import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:quizzes/_iwu_pack.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'src/base/bloc.dart';
import 'src/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    setPathUrlStrategy();
  }
  await AppPrefs.instance.initialize();

  await Future.wait([
    Firebase.initializeApp(
      options: firebaseOptionsPREPROD,
    ),
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []),
    SystemChrome.setPreferredOrientations(DeviceOrientation.values),
    AppPrefs.instance.initialize(),
    initEasyLocalization(),
  ]);

  bloc.Bloc.observer = AppBlocObserver();

  iwuSetup();
  getItSetup();
  runApp(wrapEasyLocalization(child: const _App()));
}

class _App extends StatefulWidget {
  const _App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> {
  @override
  Widget build(BuildContext context) {
    return Portal(
        child: MaterialApp.router(
      title: 'Quizzes',
      routerConfig: goRouter,
      // scrollBehavior: const ScrollBehaviorModified(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      themeMode: ThemeMode.light,
    ));
  }
}
// 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