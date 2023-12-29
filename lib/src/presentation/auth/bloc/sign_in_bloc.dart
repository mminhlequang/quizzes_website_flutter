import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzes/src/base/bloc.dart';
import 'package:quizzes/src/utils/utils.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final PageController pageController = PageController();
  final ValueNotifier<bool> loadingValue = ValueNotifier(false);
  late User _firebaseUser;

  _loadingInButton(value) {
    loadingValue.value = value;
  }

  SignInBloc() : super(SignInState()) {
    on<VerifyPhoneNumberEvent>(_mapVerifyPhoneNumberToState);
    on<VerifySMSCodeEvent>(_mapVerifySMSCodeToState);
    on<PhoneCodeSentEvent>(_mapPhoneCodeSentToState);
    on<PhoneVerificationFailedEvent>(_mapPhoneVerificationFailedToState);
    on<PhoneVerificationCompletedEvent>(
        _mapPhoneCodeVerificationCompletedToState);
    on<ChangeFormStepEvent>(_mapChangeStepRegisterState);
  }

  _mapVerifyPhoneNumberToState(
      VerifyPhoneNumberEvent event, Emitter<SignInState> emit) async {
    emit(state.update(
      phone: event.phoneNumber,
    ));
    _loadingInButton(true);
    if (event.phoneNumber != '+84979629201') {
      _loadingInButton(false);
      showSnackBar(
          msg: 'Access not allowed!', duration: const Duration(seconds: 2));
      return;
    }
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (credential) =>
            add(PhoneVerificationCompletedEvent(credential)),
        verificationFailed: (error) => add(PhoneVerificationFailedEvent(error)),
        codeSent: (verificationId, resendToken) {
          add(PhoneCodeSentEvent(verificationId, resendToken));
          add(const ChangeFormStepEvent(step: FormStep.code));
        },
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      );
    } catch (e) {
      showSnackBar(msg: e.toString());
    } finally {
      _loadingInButton(false);
    }
  }

  _mapVerifySMSCodeToState(
      VerifySMSCodeEvent event, Emitter<SignInState> emit) async {
    _loadingInButton(true);
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: state.verificationId, smsCode: event.smsCode);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _firebaseUser = userCredential.user!;
      _verificationCompleted();
    } on FirebaseAuthException catch (e) {
      appDebugPrint(e);
      emit(state.update(msg: 'Invalid OTP code'));
    } catch (e) {
      appDebugPrint(e);
      emit(state.update(msg: 'Invalid OTP code'));
    } finally {
      _loadingInButton(false);
    }
  }

  _mapPhoneCodeSentToState(
      PhoneCodeSentEvent event, Emitter<SignInState> emit) async {
    state.verificationId = event.verificationId;
  }

  _mapPhoneCodeVerificationCompletedToState(
      PhoneVerificationCompletedEvent event, Emitter<SignInState> emit) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(event.credential);
      _firebaseUser = userCredential.user!;
      _verificationCompleted();
    } on FirebaseAuthException catch (e) {
      emit(state.update(
          msg: 'Ops, seem have something wrong, let try again!\n$e'));
    } catch (e) {
      emit(state.update(
          msg: 'Ops, seem have something wrong, let try again!\n$e'));
    } finally {
      _loadingInButton(false);
    }
  }

  _mapPhoneVerificationFailedToState(
      PhoneVerificationFailedEvent event, Emitter<SignInState> emit) async {
    _loadingInButton(false);
  }

  void _codeAutoRetrievalTimeout(String verificationId) {}

  _mapChangeStepRegisterState(
      ChangeFormStepEvent event, Emitter<SignInState> emit) async {
    _loadingInButton(false);
    emit(state.update(step: event.step));
  }

  _verificationCompleted() {
    Get.back();
    Get.find<AuthBloc>().add(const AuthLoad(
      redirect: true,
    ));
  }
}
