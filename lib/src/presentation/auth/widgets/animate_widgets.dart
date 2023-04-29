import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzes/src/constants/constants.dart';
import 'package:quizzes/src/presentation/widgets/intl_phone_number_input/src/utils/phone_number.dart';
import 'package:quizzes/src/presentation/widgets/intl_phone_number_input/src/utils/selector_config.dart';
import 'package:quizzes/src/presentation/widgets/intl_phone_number_input/src/widgets/input_widget.dart';

Duration get _duration => const Duration(milliseconds: 350);

class WidgetInputPhone extends StatefulWidget {
  final FocusNode? focusNode;
  final dynamic controller;
  final dynamic onInputValidated;
  final dynamic onInputChanged;
  final dynamic onFieldSubmitted;
  final dynamic isValidated;
  const WidgetInputPhone({
    Key? key,
    this.focusNode,
    this.controller,
    this.onFieldSubmitted,
    this.onInputValidated,
    this.isValidated,
    this.onInputChanged,
  }) : super(key: key);

  @override
  State<WidgetInputPhone> createState() => _WidgetInputPhoneState();
}

class _WidgetInputPhoneState extends State<WidgetInputPhone> {
  late FocusNode focusNode;
  late TextEditingController controller;

  bool get hasFocus => focusNode.hasFocus || controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: appColorElement,
          ),
          child: InternationalPhoneNumberInput(
            textFieldController: controller,
            focusNode: focusNode,
            countries: countriesAvailable,
            onInputChanged: (_) {
              setState(() {});
              widget.onInputChanged?.call(_);
            },
            onInputValidated: widget.onInputValidated,
            onFieldSubmitted: widget.onFieldSubmitted,
            inputDecoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                border: InputBorder.none,
                hintText: 'Phone number'.tr,
                hintStyle: w400TextStyle()),
            formatInput: true,
            spaceBetweenSelectorAndTextField: 0.0,
            autoValidateMode: AutovalidateMode.disabled,
            onSaved: (PhoneNumber number) {},
            selectorConfig: SelectorConfig(
                flagbuilder: (countryCode) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: WidgetAppFlag.countryCode(
                      countryCode: countryCode,
                      height: 20,
                    ),
                  );
                },
                selectorTextStyle: w400TextStyle(),
                setSelectorButtonAsPrefixIcon: true,
                trailingSpace: false),
            textStyle: w400TextStyle(fontSize: 16.0),
          ),
        ),
        if (widget.isValidated)
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: appColorPrimary,
              radius: 10,
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
          )
      ],
    );
  }
}

class WidgetInputLogin extends StatefulWidget {
  final String? label;
  final dynamic validator;
  final EdgeInsetsGeometry? margin;
  final Function(String _)? onSubmitted;
  final Function(String _)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? next;
  final BorderRadius? borderRadius;
  final bool enable;
  final bool obscureText;
  final bool autofocus;
  final Color? fillColor;
  final Color? textColor;
  final TextInputType? inputType;
  final bool isVerified;
  final bool isPassword;
  final bool isEmail;
  final String? errorMessage;

  const WidgetInputLogin({
    Key? key,
    this.errorMessage,
    this.fillColor,
    this.textColor,
    this.label,
    this.inputType,
    this.autofocus = false,
    this.obscureText = false,
    this.enable = true,
    this.focusNode,
    this.next,
    this.borderRadius,
    this.margin,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.isVerified = false,
    this.isPassword = false,
    this.isEmail = false,
  }) : super(key: key);

  @override
  _WidgetInputLoginState createState() => _WidgetInputLoginState();
}

class _WidgetInputLoginState extends State<WidgetInputLogin>
    with TickerProviderStateMixin {
  late FocusNode focusNode;
  late TextEditingController controller;
  late bool obscureText = widget.obscureText;

  bool get hasFocus => focusNode.hasFocus || controller.text.isNotEmpty;

  bool get isAlreadyIcon => widget.isEmail || widget.isPassword;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50 + ((Get.width - 60)),
      child: Padding(
        padding: widget.margin ?? EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  widget.errorMessage!,
                  style: w300TextStyle()
                      .copyWith(color: appColorPrimary, fontSize: 10.0),
                ),
              ),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  child: TextFormField(
                    autofocus: widget.autofocus,
                    keyboardType: widget.inputType,
                    focusNode: focusNode,
                    obscureText: obscureText,
                    enabled: widget.enable,
                    controller: controller,
                    validator: widget.validator,
                    onChanged: (_) {
                      setState(() {});
                      widget.onChanged?.call(_);
                    },
                    onFieldSubmitted: (_) {
                      if (widget.next != null) {
                        widget.next!.requestFocus();
                      } else if (widget.onSubmitted != null) {
                        widget.onSubmitted?.call(_);
                      }
                    },
                    style: w500TextStyle(
                        color: hexColor('#8293AF'), fontSize: 16.0),
                    decoration: InputDecoration(
                        icon: !widget.isPassword
                            ? null
                            : Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Icon(
                                  Icons.lock,
                                  color: appColorText,
                                  size: 20,
                                ),
                              ),
                        suffixIcon: !widget.isPassword
                            ? null
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: appColorText,
                                    size: 20,
                                  ),
                                ),
                              ),
                        fillColor: hexColor('#F9F9FC'),
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(
                            widget.isPassword ? 0 : 16, 16, 16, 16)),
                  ),
                ),
                if (widget.label != null)
                  AnimatedPositioned(
                    left: isAlreadyIcon && !hasFocus ? 46 : 16,
                    top: hasFocus ? -10 : 16,
                    duration: _duration,
                    child: IgnorePointer(
                      ignoring: true,
                      child: AnimatedContainer(
                        duration: _duration,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color:
                                hasFocus ? Colors.white : hexColor('#F9F9FC'),
                            borderRadius: BorderRadius.circular(20)),
                        child: AnimatedDefaultTextStyle(
                          duration: _duration,
                          style: hasFocus
                              ? w500TextStyle(
                                  color: hexColor('#8293AF'), fontSize: 9.0)
                              : w500TextStyle(
                                  color: hexColor('#8293AF'), fontSize: 9.0),
                          child: Text(
                            widget.label!,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.isVerified &&
                    widget.errorMessage == null &&
                    !widget.isPassword)
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: CircleAvatar(
                      backgroundColor: appColorPrimary,
                      radius: 10,
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
