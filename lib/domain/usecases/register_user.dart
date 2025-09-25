import '../../data/repositories/auth_repository_impl.dart';
import '../../data/models/auth/register_response.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<RegisterResponse> call({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    String? email,
    required String phoneNumber,
  }) async {
    return await repository.register(
      username: username,
      password: password,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
