import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:onosendai/features/login/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final CyberspaceClient _client;
  AuthRepositoryImpl(this._client);

  @override
  Future<AuthTokens> login({required String email, required String password}) {
    Future<AuthTokens> tokens = _client.auth.login(email: email, password: password);
    debugPrint('Resultado del login: $tokens');
    return tokens;
  }
}
