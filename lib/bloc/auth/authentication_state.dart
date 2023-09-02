part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.isLoading = false,
    this.error = '',
    this.message = '',
  });
  final bool isLoading;
  final String error;
  final String message;

  /// copyWith method
  AuthenticationState copyWith({
    bool? isLoading,
    String? error,
    String? message,
  }) =>
      AuthenticationState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        message: message ?? this.message,
      );

  @override
  List<Object> get props => [isLoading, error, message];
}
