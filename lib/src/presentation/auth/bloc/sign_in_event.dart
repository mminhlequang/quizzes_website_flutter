part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class VerifyPhoneNumberEvent extends SignInEvent {
  final String phoneNumber;

  const VerifyPhoneNumberEvent(this.phoneNumber);
}

class VerifySMSCodeEvent extends SignInEvent {
  final String smsCode;

  const VerifySMSCodeEvent(this.smsCode);
}
 
 
class PhoneCodeSentEvent extends SignInEvent {
  final String verificationId;
  final int? resendToken;

  const PhoneCodeSentEvent(this.verificationId, this.resendToken);
}

class PhoneVerificationCompletedEvent extends SignInEvent {
  final PhoneAuthCredential credential;

  const PhoneVerificationCompletedEvent(this.credential);
}

class PhoneVerificationFailedEvent extends SignInEvent {
  final FirebaseAuthException error;

  const PhoneVerificationFailedEvent(this.error);
}
  
class ChangeFormStepEvent extends SignInEvent {
  final FormStep? step; 

  const ChangeFormStepEvent({this.step });
}
 