import 'package:dio/dio.dart';
import 'package:kifiya_challenge/core/constants/constants.dart';
import 'package:kifiya_challenge/core/network/dio/dio_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    // Initialize Dio with base options such as base URL, connection timeout, and receive timeout
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl, // Base URL for API requests
        connectTimeout: const Duration(seconds: 10), // Connection timeout duration
        receiveTimeout: const Duration(seconds: 10), // Receive timeout duration
      ),
    )..interceptors.add(ApiInterceptor()); // Add custom API interceptor for request/response handling
  }

  // Method to perform GET requests
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }
}
