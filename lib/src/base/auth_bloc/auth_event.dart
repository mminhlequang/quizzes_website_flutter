part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoad extends AuthEvent {
  final bool redirect;
  final Duration delay;

  const AuthLoad({this.redirect = true, this.delay = Duration.zero});
}

class AuthUpdateUser extends AuthEvent {
  final User? user;

  const AuthUpdateUser({this.user});
}

class LogoutEvent extends AuthEvent {}
