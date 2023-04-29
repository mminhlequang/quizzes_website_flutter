part of 'sign_in_bloc.dart';

enum FormStep {
  phone,
  code, 
}

class SignInState {
  FormStep step;

  String verificationId;
  String? phone;
  String? msg;

  SignInState({
    this.step = FormStep.phone,
    this.verificationId = '',
    this.msg,
    this.phone,
  });

  SignInState update({
    FormStep? step,
    String? verificationId,
    String? msg,
    String? phone,
  }) {
    return SignInState(
      step: step ?? this.step,
      verificationId: verificationId ?? this.verificationId,
      msg: msg,
      phone: phone ?? this.phone,
    );
  }
}
