import 'dart:convert';

import 'package:cyberspace_client/cyberspace_client.dart';

abstract class TokenStorage {
  Future<AuthTokens?> read();
  Future<void> write(AuthTokens tokens);
  Future<void> clear();
}

String encodeAuthTokens(AuthTokens tokens) => jsonEncode({
      'idToken': tokens.idToken,
      'refreshToken': tokens.refreshToken,
      'rtdbToken': tokens.rtdbToken,
    });

AuthTokens decodeAuthTokens(String raw) =>
    AuthTokens.fromJson(jsonDecode(raw) as Map<String, dynamic>);
