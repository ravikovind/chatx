import 'package:chatx/bloc/user/user_bloc.dart';
import 'package:dio/dio.dart';

/// [AuthInterceptor] is a [Interceptor] that adds the authorization header to the request.
/// [AuthInterceptor] is used to add the authorization header to the request

class AuthInterceptor extends Interceptor {
  /// [AuthInterceptor] constructor.
  /// [AuthInterceptor] requires the [token] to be passed.
  AuthInterceptor();
  final UserBloc _userBloc = UserBloc();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer ${_userBloc.state.accessToken}';
    return handler.next(options);
  }
}
