import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';

enum TextFieldErrorType { hint, normal }

class WidgetTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final TextStyle? labelTextStyle;
  final Function(String value)? onSubmitted;
  final Function(String value)? onChanged;
  final bool isPassword;
  final FocusNode? focusNode;
  final bool autoFocus;
  final Widget? sufixIconWidget;
  final dynamic formatters;
  final int? maxLines;

  final Widget? prefixW;

  final String? error;
  final TextFieldErrorType errorType;

  const WidgetTextField({
    super.key,
    this.prefixW,
    this.formatters,
    this.autoFocus = true,
    this.controller,
    this.error,
    this.errorType = TextFieldErrorType.normal,
    this.hint,
    this.label,
    this.labelTextStyle,
    this.onSubmitted,
    this.onChanged,
    this.focusNode,
    this.isPassword = false,
    this.sufixIconWidget,
    this.maxLines,
  });

  @override
  State<WidgetTextField> createState() => _WidgetTextFieldState();
}

class _WidgetTextFieldState extends State<WidgetTextField> {
  bool isHideText = false;
  TextEditingController? _controller = TextEditingController();
  FocusNode? _focusNode;

  double get _fontSize => 16;

  @override
  void initState() {
    isHideText = widget.isPassword;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller?.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller?.dispose();
    if (widget.focusNode == null) _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelTextStyle ??
                w300TextStyle(fontSize: 14, color: hexColor('#68686A')),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
        if (widget.error != null &&
            widget.errorType == TextFieldErrorType.normal) ...[
          Text(
            widget.error!,
            style: w300TextStyle(fontSize: 14, color: appColorPrimary),
          ),
          const SizedBox(height: 12),
        ],
        GestureDetector(
          onTap: () {
            _focusNode?.requestFocus();
            setState(() {});
          },
          child: Container(
            height: widget.maxLines != null
                ? _fontSize * 1.4 * widget.maxLines! + 46 - _fontSize * 1.2
                : 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: hexColor('#FAFAFA'),
              border: Border.all(
                  width: widget.error == null ? 0 : 1,
                  color: widget.error == null
                      ? Colors.transparent
                      : appColorPrimary),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                if (widget.prefixW != null) widget.prefixW!,
                Expanded(
                  child: _isHintError()
                      ? Text(
                          widget.error!,
                          maxLines: 1,
                          style: w300TextStyle(
                                  fontSize: 16, color: appColorPrimary)
                              .copyWith(overflow: TextOverflow.ellipsis),
                        )
                      : TextField(
                          maxLines: widget.maxLines,
                          inputFormatters: widget.formatters,
                          autofocus: widget.autoFocus,
                          focusNode: _focusNode,
                          onSubmitted: widget.onSubmitted,
                          onChanged: widget.onChanged,
                          textInputAction: TextInputAction.done,
                          controller: widget.controller,
                          obscureText: isHideText,
                          enableSuggestions: !widget.isPassword,
                          autocorrect: !widget.isPassword,
                          style: w300TextStyle(
                              fontSize: _fontSize,
                              height: widget.maxLines != null ? 1.4 : 1.2),
                          decoration: InputDecoration.collapsed(
                            hintStyle: w300TextStyle(
                                fontSize: _fontSize,
                                color: hexColor('#86888C')),
                            hintText: widget.hint,
                          ),
                        ),
                ),
                if (widget.sufixIconWidget != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: widget.sufixIconWidget,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _isHintError() {
    return (widget.error != null &&
        widget.errorType == TextFieldErrorType.hint);
  }
}
