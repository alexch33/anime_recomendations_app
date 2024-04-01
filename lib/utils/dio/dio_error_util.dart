import 'package:dio/dio.dart';

class DioErrorUtil {
  // general methods:------------------------------------------------------------
  static String handleError(Object error) {
    String errorDescription = "";
    if (error is DioException) {
      String? message = null;
      if (error.response?.data is Map) {
        message = error.response?.data['message'];
      }

      switch (error.type) {
        case DioExceptionType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case DioExceptionType.badCertificate:
          errorDescription = "Bad certificate";
          break;
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 429) {
            errorDescription = message ?? "Too many requests, try again latter";
          } else {
            errorDescription = message ?? "Bad Response";
          }
          break;
        case DioExceptionType.connectionError:
          errorDescription = "Server Connection Error";
          break;
        case DioExceptionType.unknown:
          errorDescription = message ?? "Unknown Error";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}
