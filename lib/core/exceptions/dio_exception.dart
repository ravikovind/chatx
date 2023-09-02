import 'package:dio/dio.dart';

/// [DioExceptionOf] is class for handling [Dio] exceptions.
/// [DioExceptionOf] implements [Exception].

class DioExceptionOf implements Exception {
  /// [errorMessage] is the error message.
  String errorMessage = 'Oops! something went wrong.';

  /// [DioException.exceptionFromDioError] is a factory constructor.
  /// It is a factory constructor.
  /// it accepts [DioException] as a parameter.
  /// It returns [DioExceptionOf] instance.
  DioExceptionOf.exceptionFromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        errorMessage = 'Request to the server was cancelled.';
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timed out.';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receiving timeout occurred.';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Request send timeout.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _statusCodeToError(error);
        break;
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') == true) {
          errorMessage = 'No Internet, Please try again.';
          break;
        }
        break;
      default:
        break;
    }
  }

  /// [_statusCodeToError] is a private method.
  /// It is used to handle [Dio] status codes.
  String _statusCodeToError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = error.response?.data?['message'];
    if (message != null && message is String && message.isNotEmpty) {
      return message;
    }
    switch (statusCode) {
      case 400:
        return 'Bad Request.';
      case 401:
        return 'Authentication failed.';
      case 403:
        return 'The authenticated user is not allowed to access the specified endpoint.';
      case 404:
        return 'The requested resource does not exist.';
      case 405:
        return 'Method not allowed. Please check the Allow header for the allowed HTTP methods.';
      case 415:
        return 'Unsupported media type. The requested content type or version number is invalid.';
      case 422:
        return 'Data validation failed.';
      case 429:
        return 'Too many requests.';
      case 500:
        return 'Internal server error.';
      default:
        return errorMessage;
    }
  }
}
