part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class RegisterEvent extends AuthenticationEvent {
  const RegisterEvent({required this.user});
  final User user;
  @override
  List<Object> get props => [user];
}

class SignInEvent extends AuthenticationEvent {
  const SignInEvent({required this.user});
  final User user;
  @override
  List<Object> get props => [user];
}

class SignOutEvent extends AuthenticationEvent {}
