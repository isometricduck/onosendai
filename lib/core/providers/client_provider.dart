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

class AuthTokensNotifier extends AsyncNotifier<AuthTokens?> {
  @override
  Future<AuthTokens?> build() async {
    final tokens = await ref.read(tokenStorageProvider).read();
    if (tokens != null) {
      ref
          .read(cyberspaceClientProvider)
          .setToken(
            tokens.idToken,
            refreshToken: tokens.refreshToken,
            rtdbToken: tokens.rtdbToken,
          );
    }
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
