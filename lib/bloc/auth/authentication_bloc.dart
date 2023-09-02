import 'dart:async';

import 'package:chatx/bloc/user/user_bloc.dart';
import 'package:chatx/data/models/user.dart';
import 'package:chatx/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required this.repository,
    required this.userBloc,
  }) : super(const AuthenticationState()) {
    on<SignInEvent>(_onSignInEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<SignOutEvent>(_onSignOutEvent);
  }

  final UserBloc userBloc;
  final AuthRepository repository;

  FutureOr<void> _onSignInEvent(
      SignInEvent event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.signIn(user: event.user);
      if (response.success) {
        final authenticatedUser = response.data as User;
        userBloc.add(SetUser(user: authenticatedUser));
        emit(
          state.copyWith(
            isLoading: false,
            message: 'success : ${response.message}',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'error : ${response.message}',
          ),
        );
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'error : ${_.toString()}',
        ),
      );
    }
  }

  FutureOr<void> _onRegisterEvent(
      RegisterEvent event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.signUp(user: event.user);
      if (response.success) {
        final authenticatedUser = response.data as User;
        userBloc.add(SetUser(user: authenticatedUser));
        emit(
          state.copyWith(
            isLoading: false,
            message: 'success : ${response.message}',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'error : ${response.message}',
          ),
        );
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'error : ${_.toString()}',
        ),
      );
    }
  }

  FutureOr<void> _onSignOutEvent(
      SignOutEvent event, Emitter<AuthenticationState> emit) {
    userBloc.add(const SetUser(user: User()));
    emit(state.copyWith(isLoading: false, error: '', message: ''));
  }
}
