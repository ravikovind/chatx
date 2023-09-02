part of 'search_user_bloc.dart';

class SearchUserState extends Equatable {
  const SearchUserState({
    this.users = const <User>[],
    this.isLoading = false,
    this.error = '',
    this.message = '',
  });

  final List<User> users;
  final bool isLoading;
  final String error;
  final String message;

  /// copyWith method is used to create a copy of the [SearchUserState] object
  /// by changing the provided values.

  SearchUserState copyWith({
    List<User>? users,
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return SearchUserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        users,
        isLoading,
        error,
        message,
      ];
}
