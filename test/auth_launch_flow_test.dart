import 'dart:convert';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onosendai/core/auth/token_storage.dart';
import 'package:onosendai/core/navigation/app_shell.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/core/prefs/app_prefs.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/login/presentation/login_dialog.dart';
import 'package:onosendai/main.dart';

class _LoadedFeedRepository implements FeedRepository {
  @override
  Future<PagedResult<Post>> fetch({int limit = 20, String? cursor}) async =>
      const PagedResult(data: [], cursor: null);

  @override
  Future<PagedResult<Reply>> fetchReplies(
    String postId, {
    int limit = 20,
    String? cursor,
  }) async => const PagedResult(data: [], cursor: null);

  @override
  Future<void> deleteReply(String replyId) async {}
}

class _MemoryAppPrefs implements AppPrefs {
  final Map<String, Object> _values;

  _MemoryAppPrefs([Map<String, Object>? values]) : _values = values ?? {};

  @override
  Future<String?> getString(String key) async => _values[key] as String?;

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async => _values[key] as bool?;

  @override
  Future<void> setBool(String key, bool value) async {
    _values[key] = value;
  }

  @override
  Future<int?> getInt(String key) async => _values[key] as int?;

  @override
  Future<void> setInt(String key, int value) async {
    _values[key] = value;
  }

  @override
  Future<double?> getDouble(String key) async => _values[key] as double?;

  @override
  Future<void> setDouble(String key, double value) async {
    _values[key] = value;
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    final value = _values[key] as List<String>?;
    return value == null ? null : List.unmodifiable(value);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    _values[key] = List<String>.unmodifiable(value);
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> clear() async {
    _values.clear();
  }
}

class _MemoryTokenStorage implements TokenStorage {
  AuthTokens? tokens;
  int reads = 0;
  int writes = 0;

  _MemoryTokenStorage(this.tokens);

  @override
  Future<AuthTokens?> read() async {
    reads += 1;
    return tokens;
  }

  @override
  Future<void> write(AuthTokens tokens) async {
    this.tokens = tokens;
    writes += 1;
  }

  @override
  Future<void> clear() async {
    tokens = null;
  }
}

class _NoopAuthTokenProvider implements AuthTokenProvider {
  @override
  Future<String?> getToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<void> onTokensRefreshed(RefreshedTokens tokens) async {}

  @override
  Future<void> onUnauthorized() async {}
}

String _jwtWithExp(int exp) {
  String encodePart(Map<String, Object> value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');

  return '${encodePart({'alg': 'none'})}.${encodePart({'exp': exp})}.sig';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'mobile cold launch shows entry buttons without validating tokens',
    (tester) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final storage = _MemoryTokenStorage(
        AuthTokens(
          idToken: _jwtWithExp(
            DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
          ),
          refreshToken: 'refresh-token',
          rtdbToken: 'rtdb-token',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tokenStorageProvider.overrideWithValue(storage),
            appPrefsProvider.overrideWithValue(_MemoryAppPrefs()),
            feedRepositoryProvider.overrideWithValue(_LoadedFeedRepository()),
          ],
          child: const MainApp(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('feed'), findsOneWidget);
      expect(storage.reads, 0);
      expect(find.byType(AppShell), findsNothing);
      expect(find.byType(LoginDialog), findsNothing);

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginDialog), findsOneWidget);
      expect(storage.reads, 0);

      await tester.tap(find.text('[ESC]'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginDialog), findsNothing);
      expect(storage.reads, 0);

      await tester.tap(find.text('feed'));
      await tester.pumpAndSettle();

      expect(storage.reads, 1);
      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(LoginDialog), findsNothing);
    },
  );

  test('app theme provider loads and stores the selected theme', () async {
    final prefs = _MemoryAppPrefs({'app_theme_id': 'matrix'});
    final container = ProviderContainer(
      overrides: [appPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    expect(container.read(appThemeProvider), AppThemeId.dark);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(appThemeProvider), AppThemeId.matrix);

    await container.read(appThemeProvider.notifier).setTheme(AppThemeId.c64);

    expect(container.read(appThemeProvider), AppThemeId.c64);
    expect(await prefs.getString('app_theme_id'), 'c64');
  });

  test('auth token refresh stores the refreshed token version', () async {
    final storage = _MemoryTokenStorage(
      AuthTokens(
        idToken: _jwtWithExp(1),
        refreshToken: 'stored-refresh-token',
        rtdbToken: 'old-rtdb-token',
      ),
    );
    final client = CyberspaceClient(
      authTokenProvider: _NoopAuthTokenProvider(),
      httpClient: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/v1/auth/refresh');
        expect(jsonDecode(request.body), {
          'refreshToken': 'stored-refresh-token',
        });

        return http.Response(
          jsonEncode({
            'idToken': 'new-id-token',
            'rtdbToken': 'new-rtdb-token',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final container = ProviderContainer(
      overrides: [
        tokenStorageProvider.overrideWithValue(storage),
        cyberspaceClientProvider.overrideWithValue(client),
      ],
    );
    addTearDown(container.dispose);

    final tokens = await container.read(authTokensProvider.future);

    expect(tokens?.idToken, 'new-id-token');
    expect(tokens?.refreshToken, 'stored-refresh-token');
    expect(tokens?.rtdbToken, 'new-rtdb-token');
    expect(storage.writes, 1);
    expect(storage.tokens?.idToken, 'new-id-token');
    expect(storage.tokens?.refreshToken, 'stored-refresh-token');
    expect(storage.tokens?.rtdbToken, 'new-rtdb-token');
    expect(client.getRefreshToken(), 'stored-refresh-token');
    expect(client.rtdbToken, 'new-rtdb-token');
  });

  testWidgets('login dialog displays auth messages', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authMessageProvider.overrideWith(
            (ref) => 'Your session expired. Please log in again.',
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: LoginDialog())),
      ),
    );

    expect(find.text('Your session expired. Please log in again.'), findsOne);
  });
}
