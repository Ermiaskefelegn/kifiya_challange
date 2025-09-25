import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

class NetworkException extends Equatable implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException._(this.message, this.statusCode);

  // For Dio errors
  NetworkException.fromDioError(DioException dioException)
    : message = _mapDioMessage(dioException),
      statusCode = dioException.response?.statusCode;

  // For unexpected errors
  const NetworkException.custom({required this.message, required this.statusCode});

  static String _mapDioMessage(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.badResponse:
        return 'Received invalid response with status code: ${dioException.response?.statusCode}';
      case DioExceptionType.badCertificate:
        return 'The certificate provided is invalid';
      case DioExceptionType.connectionTimeout:
        return 'Connection to the server timed out';
      case DioExceptionType.sendTimeout:
        return 'Timeout occurred while sending the request';
      case DioExceptionType.receiveTimeout:
        return 'Timeout occurred while receiving data from the server';
      case DioExceptionType.cancel:
        return 'The request to the server was cancelled';
      case DioExceptionType.connectionError:
        return dioException.error is SocketException
            ? 'No internet connection. Please check your network settings'
            : 'Network connection error occurred';
      case DioExceptionType.unknown:
        return 'An unknown error occurred';
    }
  }

  @override
  List<Object?> get props => [message, statusCode];
}

NetworkException parseDioError(Object error) {
  if (error is DioException) {
    // If already wrapped with NetworkException inside interceptor
    if (error.error is NetworkException) {
      return error.error as NetworkException;
    }
    return NetworkException.fromDioError(error);
  } else {
    // Non-Dio errors → fallback
    return NetworkException.custom(
      message: error.toString(),
      statusCode: -1, // custom code for unexpected errors
    );
  }
}
