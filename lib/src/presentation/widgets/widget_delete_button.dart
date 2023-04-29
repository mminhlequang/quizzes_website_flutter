import 'dart:math';

import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

class WidgetDeleteButton extends StatefulWidget {
  final VoidCallback callback;
  const WidgetDeleteButton({super.key, required this.callback});

  @override
  State<WidgetDeleteButton> createState() => _WidgetDeleteButtonState();
}

class _WidgetDeleteButtonState extends State<WidgetDeleteButton> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: isHover,
      anchor: const Aligned(
          follower: Alignment.bottomCenter,
          target: Alignment.topCenter,
          offset: Offset(0, -8)),
      portalFollower: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 6),
                  blurRadius: 20,
                  spreadRadius: 0,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Are you sure?',
                      overflow: TextOverflow.ellipsis,
                      style: w400TextStyle(fontSize: 16),
                    ),
                  ),
                  kSpacingHeight12,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetRippleButton(
                        onTap: () {
                          setState(() {
                            isHover = !isHover;
                          });
                        },
                        color: appColorElement,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: w400TextStyle(),
                          ),
                        ),
                      ),
                      kSpacingWidth12,
                      WidgetRippleButton(
                        onTap: widget.callback,
                        color: appColorText,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          child: Text(
                            'Yes',
                            style: w400TextStyle(color: appColorBackground),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Transform.rotate(
            angle: pi / 4,
            child: Container(
              height: 16,
              width: 16,
              color: appColorBackground,
            ),
          )
        ],
      ),
      child: IconButton(
          onPressed: () {
            setState(() {
              isHover = !isHover;
            });
          },
          iconSize: 20,
          icon: Icon(
            CupertinoIcons.delete_simple,
            color: appColorText,
          )),
    );
  }
}
