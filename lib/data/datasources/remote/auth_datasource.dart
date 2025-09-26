import 'package:kifiya_challenge/core/constants/constants.dart';
import 'package:kifiya_challenge/core/network/dio/dio_client.dart';
import 'package:kifiya_challenge/core/services/log_service.dart';
import 'package:kifiya_challenge/core/services/secure_storage_service.dart';
import '../../../core/network/dio/network_exception_hundler.dart';
import '../../models/auth/login_request.dart';
import '../../models/auth/login_response.dart';
import '../../models/auth/register_request.dart';
import '../../models/auth/register_response.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;
  final LogService logService;
  final SecureStorageService secureStorageService;

  AuthRemoteDataSource({required this.dioClient, required this.logService, required this.secureStorageService});

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dioClient.post(Constants.login, data: request.toJson());
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

  Future<dynamic> refreshtoken() async {
    try {
      final response = await dioClient.post(
        Constants.refreshToken,
        data: {"refreshToken": await secureStorageService.read(key: "refreshToken")},
      );

      return response.data;
    } catch (e) {
      throw parseDioError(e);
    }
  }
}
