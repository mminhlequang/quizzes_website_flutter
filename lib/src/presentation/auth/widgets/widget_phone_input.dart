import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzes/src/presentation/widgets/intl_phone_number_input/src/utils/phone_number.dart';
import 'package:quizzes/src/presentation/widgets/widget_button.dart';

import '../bloc/sign_in_bloc.dart';
import 'animate_widgets.dart';

SignInBloc get _bloc => Get.find<SignInBloc>();

class WidgetPhoneInput extends StatefulWidget {
  const WidgetPhoneInput({super.key});

  @override
  State<WidgetPhoneInput> createState() => _WidgetPhoneInputState();
}

class _WidgetPhoneInputState extends State<WidgetPhoneInput> {
  //Phone login
  PhoneNumber _phoneNumber = PhoneNumber();
  bool _phoneValidated = false;
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
          'Enter number phone',
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
        WidgetInputPhone(
          focusNode: focusNode,
          isValidated: _phoneValidated,
          onInputChanged: (number) {
            setState(() {
              _phoneNumber = number;
            });
          },
          onInputValidated: (value) {
            setState(() {
              _phoneValidated = value;
            });
          },
          onFieldSubmitted: (_) {
            if (_phoneValidated) {
              _bloc.add(VerifyPhoneNumberEvent(
                _phoneNumber.phoneNumber!,
              ));
            }
          },
        ),
        const SizedBox(
          height: 32,
        ),
        ValueListenableBuilder(
          valueListenable: _bloc.loadingValue,
          builder: (context, value, child) {
            return WidgetButton(
              enable: _phoneValidated,
              loading: value,
              label: 'Submit',
              onTap: !_phoneValidated && value
                  ? null
                  : () {
                      _bloc.add(VerifyPhoneNumberEvent(
                        _phoneNumber.phoneNumber!,
                      ));
                    },
            );
          },
        ),
      ],
    );
  }
}
