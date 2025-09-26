import 'package:dio/dio.dart';
import 'package:kifiya_challenge/core/network/dio/network_exception_hundler.dart';
import 'package:kifiya_challenge/core/services/secure_storage_service.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageService secureStorageService;

  ApiInterceptor(this.secureStorageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Always set JSON content type
    options.headers['Content-Type'] = 'application/json';

    // 🔑 Attach Authorization token if available
    final accessToken = await secureStorageService.read(key: 'access_token');
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert DioException into your custom NetworkException
    final networkException = NetworkException.fromDioError(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: networkException, // 👈 attach your custom exception here
      ),
    );
  }
}
