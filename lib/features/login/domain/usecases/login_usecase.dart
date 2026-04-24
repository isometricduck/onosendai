import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:onosendai/features/login/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<AuthTokens> call({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}
