import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/material.dart';

class AppColors extends AppColorsBase {
  AppColors._();

  static final AppColors _instance = AppColors._();

  static AppColors get instance => _instance;

  @override
  Color get text => Colors.black;

  @override
  Color get background => Colors.white;

  @override
  Color get element => Colors.grey[200]!;

  @override
  Color get primary => hexColor('00BDF9');

  @override
  Color get shimerHighlightColor => hexColor('#1C222C');

  @override
  Color get shimmerBaseColor => hexColor('#1C222C');
}
