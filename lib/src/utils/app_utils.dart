import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:quizzes/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

setFriendlyRouteName({required String title, required String url}) {
  html.document.title = title;
  html.window.history.pushState(null, title, url);
}

bool appIsBottomSheetOpen = false;
appOpenBottomSheet(
  Widget child, {
  bool isDismissible = true,
  bool enableDrag = true,
}) async {
  appIsBottomSheetOpen = true;
  var r = await showMaterialModalBottomSheet(
    enableDrag: enableDrag,
    context: appContext,
    builder: (_) => Padding(
      padding: MediaQuery.viewInsetsOf(_),
      child: child,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
  );
  appIsBottomSheetOpen = false;
  return r;
}

bool appIsDialogOpen = false;
appDialog(Widget child,
    {bool barrierDismissible = true, bool isOnlyFade = false}) async {
  appIsDialogOpen = true;
  var r = await showGeneralDialog(
    barrierLabel: "popup",
    barrierColor: Colors.black.withOpacity(.5),
    barrierDismissible: barrierDismissible,
    transitionDuration: const Duration(milliseconds: 300),
    context: appContext,
    pageBuilder: (context, anim1, anim2) {
      return child;
    },
    transitionBuilder: (context, anim1, anim2, child) {
      if (isOnlyFade) {
        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(anim1),
          child: child,
        );
      }
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim1),
        child: FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(anim1),
          child: child,
        ),
      );
    },
  );
  appIsDialogOpen = false;
  return r;
}


showSnackBar({context, required msg, Duration? duration}) {
  ScaffoldMessenger.of(context ?? appContext).showSnackBar(
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
