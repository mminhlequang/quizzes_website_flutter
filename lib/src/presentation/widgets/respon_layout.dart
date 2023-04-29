import 'dart:ui';
import 'package:flutter/material.dart'; 

T responByWidth<T>(context, T size, {T? computer, T? tablet, T? phone}) {
  if (ResponLayout.isComputer(context)) return computer ?? size;
  if (ResponLayout.isTablet(context)) return tablet ?? size;
  if (ResponLayout.isPhone(context)) return phone ?? size;
  return size;
}

T responByWidth2<T>(context, T size, [T? tablet, T? phone]) {
  if (ResponLayout.isComputer(context)) return size;
  if (ResponLayout.isTablet(context)) return tablet ?? size;
  if (ResponLayout.isPhone(context)) return phone ?? size;
  return size;
}

bool isPhoneByWidth() => logicalWidth < ResponLayout.phoneLimit;

//Size in logical pixels
get logicalScreenSize => window.physicalSize / window.devicePixelRatio;
get logicalWidth => logicalScreenSize.width;
get logicalHeight => logicalScreenSize.height;

class ResponLayout extends StatelessWidget {
  final Widget phone;
  final Widget tablet;
  final Widget computer;

  const ResponLayout({
    super.key,
    required this.phone,
    required this.tablet,
    required this.computer,
  });

  static const int phoneLimit = 480;
  static const int tabletLimit = 1280;

  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < phoneLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletLimit &&
      MediaQuery.of(context).size.width >= phoneLimit;

  static bool isComputer(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletLimit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < phoneLimit) {
          return phone;
        } else if (constraints.maxWidth < tabletLimit) {
          return tablet;
        } else {
          return computer;
        }
      },
    );
  }
}
