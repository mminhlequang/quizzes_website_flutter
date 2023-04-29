import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../constants/constants.dart';
import 'dart:html' as html;

setFriendlyRouteName({required String title, required String url}) {
  html.document.title = title;
  html.window.history.pushState(null, title, url);
}

showSnackBar({context, required msg, Duration? duration}) {
  ScaffoldMessenger.of(context ?? Get.context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: w300TextStyle(color: appColorBackground),
      ),
      duration: duration ?? const Duration(seconds: 1),
      backgroundColor: appColorText,
    ),
  );
}

bool isImageByMime(type) {
  switch (type) {
    case 'image/jpeg':
    case 'image/png':
      return true;
    default:
      return false;
  }
}
