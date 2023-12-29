import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quizzes/src/presentation/widgets/intl_phone_number_input/src/utils/phone_number.dart';
import 'package:quizzes/src/presentation/widgets/widget_button.dart';

import '../bloc/sign_in_bloc.dart';
import 'animate_widgets.dart';

SignInBloc get _bloc => Get.find<SignInBloc>();

class WidgetCodeInput extends StatefulWidget {
  const WidgetCodeInput({super.key});

  @override
  State<WidgetCodeInput> createState() => _WidgetCodeInputState();
}

class _WidgetCodeInputState extends State<WidgetCodeInput> {
  //Code
  String code = '';
  bool _isCodeCompleted = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'LOGIN',
          style: w500TextStyle(fontSize: 24),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Enter OTP code recieved',
          style: w500TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          width: 80,
          height: 2,
          decoration: BoxDecoration(
              color: appColorElement, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PinCodeTextField(
            key: const ValueKey(FormStep.code),
            focusNode: focusNode,
            appContext: context,
            length: 6,
            keyboardType: TextInputType.number,
            obscureText: false,
            autoDismissKeyboard: false,
            enableActiveFill: true,
            animationType: AnimationType.fade,
            textStyle: w700TextStyle().copyWith(fontSize: 24.0),
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                fieldHeight: 45,
                fieldWidth: 45,
                borderWidth: 1.5,
                borderRadius: BorderRadius.circular(20),
                selectedColor: appColorElement,
                inactiveColor: appColorElement,
                activeColor: appColorElement,
                activeFillColor: appColorElement,
                inactiveFillColor: appColorElement,
                selectedFillColor: appColorElement),
            onCompleted: (v) {
              setState(() {
                _isCodeCompleted = true;
              });
              _bloc.add(VerifySMSCodeEvent(code));
            },
            onChanged: (value) {
              code = value;
              setState(() {
                _isCodeCompleted = value.length == 6;
              });
            },
            beforeTextPaste: (text) {
              return true;
            },
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        ValueListenableBuilder(
          valueListenable: _bloc.loadingValue,
          builder: (context, value, child) {
            return WidgetButton(
              enable: _isCodeCompleted,
              loading: value,
              label: 'Submit',
              onTap: !_isCodeCompleted && value
                  ? null
                  : () {
                      _bloc.add(VerifySMSCodeEvent(code));
                    },
            );
          },
        ),
      ],
    );
  }
}
