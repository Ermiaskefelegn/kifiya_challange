import 'package:dio/dio.dart';
import 'package:kifiya_challenge/core/network/dio/network_exception_hundler.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({'Content-Type': 'application/json'});
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert DioException into your custom NetworkException
    final networkException = NetworkException.fromDioError(err);

    // Forward the error wrapped in DioError but attach your custom exception
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: networkException, // 👈 attach your NetworkException here
      ),
    );
  }
}
