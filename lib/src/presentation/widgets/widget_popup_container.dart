import 'dart:math';

import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';

class WidgetPopupContainer extends StatelessWidget {
  final Widget child;
  final Alignment? alignmentTail;
  final EdgeInsets? paddingTail;
  final BorderRadius? borderRadius;
  const WidgetPopupContainer({
    super.key,
    required this.child,
    this.alignmentTail,
    this.paddingTail,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignmentTail ?? Alignment.topRight,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: appColorText.withOpacity(.1), blurRadius: 12)
              ],
              color: appColorBackground,
              borderRadius: BorderRadius.circular(16)),
          child: child,
        ),
        Padding(
          padding: paddingTail ?? const EdgeInsets.only(right: 28),
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              height: 16,
              width: 16,
              color: appColorBackground,
            ),
          ),
        )
      ],
    );
  }
}
