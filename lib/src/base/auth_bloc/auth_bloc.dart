import 'dart:async';

import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../presentation/auth/authenticate_screen.dart';

part 'auth_event.dart';
part 'auth_state.dart';

enum AuthStateType { none, logged }

String? get loggedUid => Get.find<AuthBloc>().state.user?.uid;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  StreamSubscription? _subscription;

  AuthBloc() : super(AuthState()) {
    on<AuthLoad>(_load);
    on<LogoutEvent>(_logout);
    on<AuthUpdateUser>(_update);
  }

  _update(AuthUpdateUser event, Emitter<AuthState> emit) async {
    state.user = event.user;
    if (state.user == null) {
      add(LogoutEvent());
    }
  }

  _load(AuthLoad event, Emitter<AuthState> emit) async {
    User? user;
    try {
      if (kDebugMode) await FirebaseAuth.instance.signInAnonymously();
      if (FirebaseAuth.instance.currentUser != null) {
        user = FirebaseAuth.instance.currentUser;
        emit(state.update(stateType: AuthStateType.logged));
      } else {
        emit(state.update(stateType: AuthStateType.none));
      }
    } catch (e) {
      emit(state.update(stateType: AuthStateType.none));
    }
    if (state.stateType == AuthStateType.logged) {
      state.user = user;
      _subscription?.cancel();
      _subscription =
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
        add(AuthUpdateUser(user: user));
      });
      // appDebugPrint('[auth]: ${user?.toString()}');
      // if (user?.phoneNumber == null) {
      //   throw Exception('[auth]:phoneNumber can\'t null');
      // }
    }

    await Future.delayed(event.delay);
    _redirect();
  }

  _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    _subscription?.cancel();
    try {
      emit(state.update(stateType: AuthStateType.none));
      _redirect();
    } catch (e) {}
  }

  _redirect() {
    if (state.stateType == AuthStateType.logged) {
      // Get.offAllNamed(Routes.nav);
    } else {
      Get.dialog(const AuthenticateScreen());
    }
  }
}
