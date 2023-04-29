import 'package:get/get.dart';

class AppValid {
  AppValid._();

  static validateNumberSerial() {
    return (value) {
      if (value == null || value.length == 0) {
        return 'valid_number_serial'.tr;
      }
      return null;
    };
  }

  static validatePassword() {
    return (value) {
      if (value == null || value.length < 6) {
        return 'valid_password'.tr;
      } else {
        RegExp regex = new RegExp(r'^[0-9a-zA-Z!@#\$&*~]{6,}$');
        if (!regex.hasMatch(value))
          return 'valid_password'.tr;
        else
          return null;
      }
    };
  }
}
