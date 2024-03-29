import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class AppThemes {
  static ThemeData get appTheme {
    bool isDarkMode = AppPrefs.instance.themeModel == "dark";
    return (isDarkMode ? ThemeData.dark() : ThemeData.light()).copyWith(
      primaryColor: appColorPrimary,
      scaffoldBackgroundColor: appColorBackground,
    );
  }

  static TextTheme get textTheme => appTheme.textTheme;
}
