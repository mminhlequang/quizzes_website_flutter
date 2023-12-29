import 'dart:io';

import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class AppPrefs extends AppPrefsBase {
  AppPrefs._();

  static final AppPrefs _instance = AppPrefs._();

  static AppPrefs get instance => _instance;

  late Box _box;
  bool _initialized = false;

  initListener() async {
    if (_initialized) return;
    if (!kIsWeb) {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocDirectory.path);
    }
    _box = await Hive.openBox('AppPref');
    _initialized = true;
  }

  Stream watch(key) => _box.watch(key: key);

  void clear() {
    _box.delete('accessToken');
    _box.delete('themeModel');
  }

  set themeModel(String? value) => _box.put('themeModel', value);

  String? get themeModel => _box.get('themeModel');

  @override
  set languageCode(String? value) => _box.put('languageCode', value);

  @override
  String get languageCode => _box.get('languageCode') ?? 'en';

  @override
  set dateFormat(String value) => _box.put('dateFormat', value);

  @override
  String get dateFormat => _box.get('dateFormat') ?? 'en';

  @override
  set timeFormat(String value) => _box.put('timeFormat', value);

  @override
  String get timeFormat => _box.get('timeFormat') ?? 'en';
}
