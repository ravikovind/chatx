import 'package:chatx/core/exceptions/dio_exception.dart';
import 'package:chatx/data/models/user.dart';
import 'package:dio/dio.dart' as client;
import 'package:response_x/response_x.dart';

/// [AuthService] is a class that handles all the authentication related
/// operations.
class AuthService {
  /// constructor for [AuthService].
  AuthService({required this.dio}) {
    dio.options.baseUrl = 'http://192.168.1.4:3000/api/v1/auth';
    dio.options.sendTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.responseType = client.ResponseType.json;
    dio.options.contentType = client.Headers.formUrlEncodedContentType;
  }

  /// [dio] is the [Dio] instance used to make all the requests.
  /// [dio] is required to make all the requests.
  final client.Dio dio;

  /// [signUp] method is used to sign up a user.
  /// [user] is the user object that contains all the details of the user.
  Future<Response> signUp({required User user}) async {
    try {
      final response = await dio.post(
        '/signUp',
        data: user.toJson(),
      );
      if (response.statusCode == 201) {
        final userOf = User.fromJson(response.data ?? <String, dynamic>{});
        return Response.success(
          message: 'sign up successful!',
          data: userOf,
        );
      } else {
        final error = response.data?['message']?.toString();
        return Response.failure(
          statusCode: response.statusCode ?? 500,
          message: error ?? 'something went wrong!',
        );
      }
    } on client.DioException catch (error) {
      final errorOf = DioExceptionOf.exceptionFromDioError(error);
      return Response.failure(
        statusCode: error.response?.statusCode ?? 500,
        message: errorOf.errorMessage,
      );
    } on Exception {
      return Response.failure(
        statusCode: 500,
        message: 'Error : Unexpected error occurred.',
      );
    }
  }

  /// [signIn] method is used to sign in a user.
  /// [user] is the user object that contains all the details of the user.
  Future<Response> signIn({required User user}) async {
    try {
      final response = await dio.post(
        '/signIn',
        data: user.toJson(),
      );
      if (response.statusCode == 200) {
        final userOf = User.fromJson(response.data ?? <String, dynamic>{});
        return Response.success(
          message: 'sign in successful!',
          data: userOf,
        );
      } else {
        final error = response.data?['message']?.toString();
        return Response.failure(
          statusCode: response.statusCode ?? 500,
          message: error ?? 'something went wrong!',
        );
      }
    } on client.DioException catch (error) {
      final errorOf = DioExceptionOf.exceptionFromDioError(error);
      return Response.failure(
        statusCode: error.response?.statusCode ?? 500,
        message: errorOf.errorMessage,
      );
    } on Exception {
      return Response.failure(
        statusCode: 500,
        message: 'Error : Unexpected error occurred.',
      );
    }
  }
}
