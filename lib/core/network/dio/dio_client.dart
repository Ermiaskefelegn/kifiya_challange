import 'package:dio/dio.dart';
import 'package:kifiya_challenge/core/constants/constants.dart';
import 'package:kifiya_challenge/core/network/dio/dio_interceptor.dart';
import 'package:kifiya_challenge/core/services/secure_storage_service.dart';

class DioClient {
  late final Dio _dio;

  DioClient(SecureStorageService secureStorageService) {
    // Initialize Dio with base options such as base URL, connection timeout, and receive timeout
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl, // Base URL for API requests
        connectTimeout: const Duration(seconds: 10), // Connection timeout duration
        receiveTimeout: const Duration(seconds: 10), // Receive timeout duration
      ),
    )..interceptors.add(ApiInterceptor(secureStorageService)); // ✅ attach interceptor with tokens
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _dio.get(path, queryParameters: queryParameters);

  Future<Response> post(String path, {Map<String, dynamic>? data}) => _dio.post(path, data: data);

  Future<Response> put(String path, {Map<String, dynamic>? data}) => _dio.put(path, data: data);

  Future<Response> delete(String path, {Map<String, dynamic>? data}) => _dio.delete(path, data: data);

  Future<Response> patch(String path, {Map<String, dynamic>? data}) => _dio.patch(path, data: data);
}
