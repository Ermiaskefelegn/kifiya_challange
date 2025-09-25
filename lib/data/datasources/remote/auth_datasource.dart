import 'package:dio/dio.dart';
import 'package:kifiya_challenge/core/constants/constants.dart';
import 'package:kifiya_challenge/core/network/dio/dio_client.dart';
import 'package:kifiya_challenge/core/services/hive_storage_service.dart';
import 'package:kifiya_challenge/core/services/log_service.dart';
import 'package:kifiya_challenge/core/services/secure_storage_service.dart';
import '../../../core/network/dio/network_exception_hundler.dart';
import '../../models/auth/login_request.dart';
import '../../models/auth/login_response.dart';
import '../../models/auth/register_request.dart';
import '../../models/auth/register_response.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;
  final SecureStorageService secureStorageService;
  final HiveStorageService hiveStorageService;
  final LogService logService;

  AuthRemoteDataSource({
    required this.dioClient,
    required this.secureStorageService,
    required this.hiveStorageService,
    required this.logService,
  });

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dioClient.post(Constants.login, data: request.toJson());
      final loginResponse = LoginResponse.fromJson(response.data);
      await secureStorageService.write(key: 'access_token', value: loginResponse.accessToken);
      await secureStorageService.write(key: 'refresh_token', value: loginResponse.refreshToken);
      await hiveStorageService.set('user_id', loginResponse.userId.toString());
      await hiveStorageService.set('username', loginResponse.username);

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw parseDioError(e);
    }
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await dioClient.post(Constants.register, data: request.toJson());
      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      throw parseDioError(e);
    }
  }
}
