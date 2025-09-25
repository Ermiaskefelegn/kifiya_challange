import '../../data/repositories/auth_repository_impl.dart';
import '../../data/models/auth/login_response.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<LoginResponse> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
