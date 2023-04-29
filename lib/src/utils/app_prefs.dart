import 'dart:io';
 
import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppPrefs extends AppPrefsBase {
  AppPrefs._();

  static final AppPrefs _instance = AppPrefs._();

  static AppPrefs get instance => _instance;

  late Box _box;
  late final FlutterSecureStorage _secureStorage;
  bool _initialized = false;

  initListener() async {
    if (_initialized) return;
    if (!kIsWeb) {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      Hive..init(appDocDirectory.path);
    }
    _box = await Hive.openBox('AppPref');
    _securityAccount ??=
        'flutter_secure_storage_service_${DateTime.now().millisecondsSinceEpoch}';
    _secureStorage = FlutterSecureStorage(
        iOptions: IOSOptions(accountName: _securityAccount!));
    _initialized = true;
  }

  Stream watch(key) => _box.watch(key: key);

  void clear() {
    _box.delete('accessToken');
    _box.delete('themeModel');
  }

  set _securityAccount(String? value) => _box.put('_securityAccount', value);

  String? get _securityAccount => _box.get('_securityAccount');

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
