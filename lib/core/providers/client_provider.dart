import 'dart:convert';
import 'dart:io';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/auth/file_token_storage.dart';
import 'package:onosendai/core/auth/secure_storage_token_storage.dart';
import 'package:onosendai/core/auth/token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  if (Platform.isLinux || Platform.isMacOS) return FileTokenStorage();
  return SecureStorageTokenStorage();
});

final authTokensProvider =
    AsyncNotifierProvider<AuthTokensNotifier, AuthTokens?>(
      AuthTokensNotifier.new,
    );

final authMessageProvider = StateProvider<String?>((ref) => null);

bool _isTokenExpired(String idToken) {
  try {
    final parts = idToken.split('.');
    if (parts.length != 3) return true;
    var payload = parts[1];
    payload += '=' * ((4 - payload.length % 4) % 4);
    final claims =
        jsonDecode(utf8.decode(base64Url.decode(payload))) as Map<String, dynamic>;
    final exp = claims['exp'];
    if (exp is! int) return true;
    // Treat tokens expiring within 30 seconds as already expired.
    return DateTime.now().millisecondsSinceEpoch >= (exp - 30) * 1000;
  } catch (_) {
    return true;
  }
}

class AuthTokensNotifier extends AsyncNotifier<AuthTokens?> {
  @override
  Future<AuthTokens?> build() async {
    final storage = ref.read(tokenStorageProvider);
    final tokens = await storage.read();
    if (tokens == null) return null;

    if (_isTokenExpired(tokens.idToken)) {
      try {
        final refreshed = await ref
            .read(cyberspaceClientProvider)
            .auth
            .refreshToken(tokens.refreshToken);
        final newTokens = AuthTokens(
          idToken: refreshed.idToken,
          refreshToken: tokens.refreshToken,
          rtdbToken: refreshed.rtdbToken,
        );
        await storage.write(newTokens);
        ref.read(cyberspaceClientProvider).setToken(
          newTokens.idToken,
          refreshToken: newTokens.refreshToken,
          rtdbToken: newTokens.rtdbToken,
        );
        return newTokens;
      } on CyberspaceApiException catch (e) {
        if (e.statusCode == 401) {
          await storage.clear();
          ref.read(authMessageProvider.notifier).state =
              'Your session expired. Please log in again.';
          return null;
        }
        // Server error — fall through with the expired token; reactive path will retry.
      } catch (_) {
        // Network error — fall through with the expired token; reactive path will retry.
      }
    }

    ref.read(cyberspaceClientProvider).setToken(
      tokens.idToken,
      refreshToken: tokens.refreshToken,
      rtdbToken: tokens.rtdbToken,
    );
    return tokens;
  }

  Future<void> set(AuthTokens tokens) async {
    await ref.read(tokenStorageProvider).write(tokens);
    ref
        .read(cyberspaceClientProvider)
        .setToken(
          tokens.idToken,
          refreshToken: tokens.refreshToken,
          rtdbToken: tokens.rtdbToken,
        );
    ref.read(authMessageProvider.notifier).state = null;
    state = AsyncData(tokens);
  }

  Future<void> clear({String? message}) async {
    await ref.read(tokenStorageProvider).clear();
    ref.read(cyberspaceClientProvider).clearToken();
    ref.read(authMessageProvider.notifier).state = message;
    state = const AsyncData(null);
  }
}

class _RiverpodAuthTokenProvider implements AuthTokenProvider {
  final Ref _ref;
  _RiverpodAuthTokenProvider(this._ref);

  @override
  Future<String?> getToken() async =>
      _ref.read(authTokensProvider).valueOrNull?.idToken;

  @override
  Future<String?> getRefreshToken() async =>
      _ref.read(authTokensProvider).valueOrNull?.refreshToken;

  @override
  Future<void> onTokensRefreshed(RefreshedTokens tokens) async {
    final current = _ref.read(authTokensProvider).valueOrNull;
    if (current == null) {
      await _ref.read(authTokensProvider.notifier).clear();
      return;
    }

    await _ref
        .read(authTokensProvider.notifier)
        .set(
          AuthTokens(
            idToken: tokens.idToken,
            refreshToken: current.refreshToken,
            rtdbToken: tokens.rtdbToken,
          ),
        );
  }

  @override
  Future<void> onUnauthorized() async {
    await _ref
        .read(authTokensProvider.notifier)
        .clear(message: 'Your session expired. Please log in again.');
  }
}

final cyberspaceClientProvider = Provider<CyberspaceClient>((ref) {
  return CyberspaceClient(authTokenProvider: _RiverpodAuthTokenProvider(ref));
});
