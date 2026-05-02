import 'dart:convert';
import 'dart:io';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/auth/file_token_storage.dart';
import 'package:onosendai/core/auth/secure_storage_token_storage.dart';
import 'package:onosendai/core/auth/token_storage.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';

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
  debugPrint("Checking if token is expired");
  try {
    final parts = idToken.split('.');
    if (parts.length != 3) return true;
    var payload = parts[1];
    payload += '=' * ((4 - payload.length % 4) % 4);
    debugPrint("Payload: $payload");
    final claims =
        jsonDecode(utf8.decode(base64Url.decode(payload)))
            as Map<String, dynamic>;
    debugPrint("Claims: $claims");
    final exp = claims['exp'];
    debugPrint(
      'Token exp: $exp, now: ${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
    );
    if (exp is! int) return true;
    // Treat tokens expiring within 30 seconds as already expired.
    return DateTime.now().millisecondsSinceEpoch >= (exp - 30) * 1000;
  } catch (e) {
    debugPrint("Error checking token: $e");
    return true;
  }
}

class AuthTokensNotifier extends AsyncNotifier<AuthTokens?> {
  @override
  Future<AuthTokens?> build() async {
    debugPrint("Building token notifier");
    final storage = ref.read(tokenStorageProvider);
    debugPrint("Storage: $storage");
    final tokens = await storage.read();
    debugPrint("Tokens: $tokens");
    if (tokens == null) return null;

    if (_isTokenExpired(tokens.idToken)) {
      debugPrint("Expired token");
      try {
        debugPrint("Refresh token: ${tokens.refreshToken}");
        final refreshed = await ref
            .read(cyberspaceClientProvider)
            .auth
            .refreshToken(tokens.refreshToken);
        debugPrint("refreshed token: $refreshed");
        final newTokens = AuthTokens(
          idToken: refreshed.idToken,
          refreshToken: tokens.refreshToken,
          rtdbToken: refreshed.rtdbToken,
        );
        await storage.write(newTokens);
        ref
            .read(cyberspaceClientProvider)
            .setToken(
              newTokens.idToken,
              refreshToken: newTokens.refreshToken,
              rtdbToken: newTokens.rtdbToken,
            );
        return newTokens;
      } on CyberspaceApiException catch (e) {
        debugPrint("API exception on refresh: ${e.statusCode} $e");
        if (e.statusCode == 401) {
          await storage.clear();
          ref.read(authMessageProvider.notifier).state =
              'Your session expired. Please log in again.';
          return null;
        }
        // Server error — fall through with the expired token; reactive path will retry.
      } catch (e) {
        debugPrint("Other error when refreshing token: $e");
        // Network error — fall through with the expired token; reactive path will retry.
      }
    } else {
      debugPrint("Not expired token");
    }

    ref
        .read(cyberspaceClientProvider)
        .setToken(
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
    await Future.wait([
      ref.read(currentUserPrefsProvider).clear(),
      ref.read(bookmarkedItemsPrefsProvider).clear(),
    ]);
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
  return CyberspaceClient(
    authTokenProvider: _RiverpodAuthTokenProvider(ref),
  ); //, baseUrl: "http://10.0.2.2:6000");
});
