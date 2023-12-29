import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

class WidgetCopyable extends StatelessWidget {
  final String text;
  final Widget child;

  const WidgetCopyable({
    super.key,
    required this.text,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey copyButtonKey = GlobalKey();
    return InkWell(
      key: copyButtonKey,
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        // RenderBox box =
        //     copyButtonKey.currentContext!.findRenderObject()! as RenderBox;
        // Offset position = box.localToGlobal(Offset.zero);
        // _toast(position, box.size);
      },
      child: child,
    );
  }
}

class WidgetTextCopyable extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;

  const WidgetTextCopyable(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey copyButtonKey = GlobalKey();
    return InkWell(
      key: copyButtonKey,
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        // RenderBox box =
        //     copyButtonKey.currentContext!.findRenderObject()! as RenderBox;
        // Offset position = box.localToGlobal(Offset.zero);
        // _toast(position, box.size);
      },
      child: Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: style,
      ),
    );
  }
}
