import 'dart:async';

import 'package:chatx/data/models/user.dart';
import 'package:chatx/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'search_user_event.dart';
part 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  SearchUserBloc({
    required this.repository,
  }) : super(const SearchUserState()) {
    on<SearchUser>(_onSearchUser);
  }

  final UserRepository repository;

  FutureOr<void> _onSearchUser(
      SearchUser event, Emitter<SearchUserState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    final response = await repository.searchUser(name: event.name);
    if (response.success) {
      final users = response.data as List<User>;
      emit(state.copyWith(
        users: <User>[...users],
        isLoading: false,
        message: response.message,
      ));
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          error: response.message,
        ),
      );
    }
  }
}
