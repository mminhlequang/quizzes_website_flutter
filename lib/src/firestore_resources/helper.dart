import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

User get currentUser => FirebaseAuth.instance.currentUser!;

String _qrPrefix = 'qr-smonthslide-tv:';

String qrBySerial(id, {String? os}) {
  return '$_qrPrefix${genDeviceId(id, os: os)}';
}

String genDeviceId(String id, {String? os}) {
  return "${os ?? Platform.operatingSystem}-$id";
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
 