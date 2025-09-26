import 'package:kifiya_challenge/data/repositories/auth_repository_impl.dart';

class RefreshToken {
  final AuthRepository _authRepository;

  RefreshToken(this._authRepository);

  Future<dynamic> call() async {
    return await _authRepository.refreshtoken();
  }
}
