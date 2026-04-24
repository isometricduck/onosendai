import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:onosendai/core/auth/token_storage.dart';

class SecureStorageTokenStorage implements TokenStorage {
  static const _key = 'auth_tokens';

  final FlutterSecureStorage _storage;

  SecureStorageTokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<AuthTokens?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    return decodeAuthTokens(raw);
  }

  @override
  Future<void> write(AuthTokens tokens) =>
      _storage.write(key: _key, value: encodeAuthTokens(tokens));

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
