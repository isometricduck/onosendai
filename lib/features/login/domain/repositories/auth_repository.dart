import 'package:cyberspace_client/cyberspace_client.dart';

abstract class AuthRepository {
  Future<AuthTokens> login({required String email, required String password});
}
