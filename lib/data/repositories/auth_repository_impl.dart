import '../datasources/remote/auth_datasource.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../models/auth/register_request.dart';
import '../models/auth/register_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String username, String password);
  Future<RegisterResponse> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    String? email,
    required String phoneNumber,
  });
  Future<dynamic> refreshtoken() async {}
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  Future<LoginResponse> login(String username, String password) async {
    final request = LoginRequest(username: username, passwordHash: password);
    return await _authRemoteDataSource.login(request);
  }

  @override
  Future<RegisterResponse> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    String? email,
    required String phoneNumber,
  }) async {
    final request = RegisterRequest(
      username: username,
      passwordHash: password,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
    );
    return await _authRemoteDataSource.register(request);
  }

  @override
  Future<dynamic> refreshtoken() async {
    return await _authRemoteDataSource.refreshtoken();
  }
}
