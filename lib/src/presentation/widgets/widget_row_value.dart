import 'dart:math';

import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'widget_check.dart';
import 'widget_popup_container.dart';
import 'widget_textfield.dart';

class WidgetRowHeader extends StatelessWidget {
  final Widget child;
  const WidgetRowHeader({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: child,
    );
  }
}

class WidgetRowItem extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  const WidgetRowItem({Key? key, required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: onTap != null
            ? IgnorePointer(
                child: child,
              )
            : child,
      ),
    );
  }
}

enum CellDataType { string, bol, date }

class WidgetRowValue extends StatefulWidget {
  //For display
  final int flex;
  final Alignment alignment;
  final int maxLines;
  // String? // Widget
  final dynamic value;
  final bool isLabel;
  final dynamic valueEdit;

  // String? // Widget
  final dynamic valueHover;

  //For edit
  final double inputWidth;
  final int inputMaxLines;
  final ValueChanged? callback;
  final CellDataType cellDataType;
  final String? label;
  const WidgetRowValue({
    Key? key,
    required this.value,
    this.valueEdit,
    this.alignment = Alignment.centerLeft,
    this.flex = 1,
    this.inputWidth = 400,
    this.maxLines = 1,
    this.inputMaxLines = 5,
    this.callback,
    this.cellDataType = CellDataType.string,
    this.label,
    this.valueHover,
  })  : isLabel = false,
        super(key: key);

  const WidgetRowValue.label({
    Key? key,
    required this.value,
    this.alignment = Alignment.centerLeft,
    this.flex = 1,
  })  : isLabel = true,
        valueHover = null,
        valueEdit = null,
        maxLines = 1,
        inputMaxLines = 1,
        inputWidth = 400,
        callback = null,
        label = null,
        cellDataType = CellDataType.string,
        super(key: key);

  @override
  State<WidgetRowValue> createState() => _WidgetRowValueState();
}

class _WidgetRowValueState extends State<WidgetRowValue> {
  final GlobalKey<WidgetOverlayActionsState> globalKey = GlobalKey();
  var hide;
  bool isHover = false;

  static TextStyle get textStyleLabel => w400TextStyle();
  static TextStyle get textStyleValue => w300TextStyle();

  @override
  Widget build(BuildContext context) {
    Widget childW = const SizedBox();
    switch (widget.cellDataType) {
      case CellDataType.string:
        childW = SizedBox(
          width:
              min(widget.inputWidth, MediaQuery.of(context).size.width * .85),
          child: WidgetTextField(
            label: widget.label,
            maxLines: widget.inputMaxLines,
            controller: TextEditingController(
              text: widget.valueEdit ?? widget.value.toString(),
            )..selection =
                TextSelection.collapsed(offset: widget.value.toString().length),
            autoFocus: true,
            onSubmitted: (value) {
              hide();
              widget.callback?.call(value);
            },
          ),
        );
        break;
      case CellDataType.bol:
        childW = WidgetCheck(
          status: widget.value,
          label: widget.label ?? '',
          callback: (value) {
            hide();
            widget.callback?.call(value);
          },
        );

        break;
      default:
    }
    return Expanded(
      flex: widget.flex,
      child: Align(
        alignment: widget.alignment,
        child: WidgetOverlayActions(
          key: globalKey,
          gestureType: GestureType.none,
          child: InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(
                text: widget.value is Widget ? '' : widget.value.toString(),
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Text copied success!",
                    style: w300TextStyle(color: appColorBackground),
                  ),
                  duration: const Duration(milliseconds: 500),
                  backgroundColor: appColorText,
                ),
              );
            },
            onDoubleTap: () {
              globalKey.currentState?.showMenu();
            },
            onHover: (value) {
              if (widget.valueHover != null) {
                setState(() {
                  isHover = value;
                });
              }
            },
            child: PortalTarget(
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
                    child: widget.valueHover is Widget
                        ? widget.valueHover
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.valueHover.toString(),
                              maxLines: widget.maxLines,
                              overflow: TextOverflow.ellipsis,
                              style: textStyleValue,
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
              child: widget.value is Widget
                  ? widget.value
                  : Text(
                      widget.value.toString(),
                      maxLines: widget.maxLines,
                      overflow: TextOverflow.ellipsis,
                      style: widget.isLabel ? textStyleLabel : textStyleValue,
                    ),
            ),
          ),
          builder: (child, size, childPosition, pointerPosition, animationValue,
              hide) {
            this.hide = hide;
            return Positioned(
              left: childPosition.dx - 12,
              top: childPosition.dy + size.height + 4,
              child: WidgetPopupContainer(
                alignmentTail: Alignment.topLeft,
                paddingTail: const EdgeInsets.only(left: 28),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: childW,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
