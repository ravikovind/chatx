import 'dart:async';
import 'package:chatx/data/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'user_event.dart';

class UserBloc extends HydratedBloc<UserEvent, User> with ChangeNotifier {
  UserBloc() : super(const User()) {
    on<SetUser>(_onSetUser);
    on<CheckUserState>(_onCheckUserState);
  }

  FutureOr<void> _onSetUser(SetUser event, Emitter<User> emit) async {
    final user = event.user;
    emit(user);
    notifyListeners();
  }

  FutureOr<void> _onCheckUserState(CheckUserState event, Emitter<User> emit) {
    final user = state;
    emit(user);
    notifyListeners();
  }

  @override
  User? fromJson(Map<String, dynamic> json) => User.fromJson(json);

  @override
  Map<String, dynamic>? toJson(User state) => state.toJson();
}

