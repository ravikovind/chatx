import 'package:chatx/core/exceptions/dio_exception.dart';
import 'package:chatx/core/interceptors/auth_interceptor.dart';
import 'package:chatx/data/models/conversation.dart';
import 'package:chatx/data/models/user.dart';
import 'package:dio/dio.dart' as client;
import 'package:response_x/response_x.dart';

/// [UserService] is a class that handles all the authentication related
/// operations.
class UserService {
  /// constructor for [UserService].
  UserService({required this.dio}) {
    dio.options.baseUrl = 'http://192.168.1.4:3000/api/v1/user';
    dio.options.sendTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.responseType = client.ResponseType.json;
    dio.options.contentType = client.Headers.formUrlEncodedContentType;
    dio.interceptors.add(AuthInterceptor());
  }

  /// [dio] is the [Dio] instance used to make all the requests.
  /// [dio] is required to make all the requests.
  final client.Dio dio;

  /// conversations method is used to get all the conversations of the user.
  Future<Response> conversations() async {
    try {
      final response = await dio.get(
        '/conversations',
      );
      if (response.statusCode == 200) {
        final conversations = List<Conversation>.from(
          response.data?.map(
                (x) => Conversation.fromJson(x),
              ) ??
              <Conversation>[],
        );
        return Response.success(
          message: 'conversations fetched successfully!',
          data: conversations,
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

  /// createConversation method is used to create a new conversation.

  Future<Response> createConversation({
    required Conversation conversation,
  }) async {
    try {
      final data = {
        ...conversation.entity,
      };
      print('conversation : ${conversation.entity} ended data : $data started');
      final response = await dio.post(
        '/conversation',
        data: data,
      );
      if (response.statusCode == 200) {
        return Response.success(
          message: 'conversation created successfully!',
        );
      } else {
        final error = response.data?['message']?.toString();
        return Response.failure(
          statusCode: response.statusCode ?? 500,
          message: error ?? 'something went wrong!',
        );
      }
    } on client.DioException catch (error) {
      print(
        'conversation : ${conversation.entity} ended response.requestOptions.data : ${error.requestOptions.data}} started',
      );

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

  /// searchUser method is used to search for a user.
  Future<Response> users({
    required String name,
  }) async {
    try {
      final response = await dio.get(
        '/search',
        queryParameters: {
          'name': name,
        },
      );
      if (response.statusCode == 200) {
        final users = List<User>.from(
          response.data?.map(
                (x) => User.fromJson(x),
              ) ??
              <User>[],
        );
        return Response.success(
          message: 'users fetched successfully!',
          data: users,
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
