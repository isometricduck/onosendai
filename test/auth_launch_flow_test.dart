import 'dart:convert';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onosendai/core/auth/token_storage.dart';
import 'package:onosendai/core/navigation/app_ui.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/core/prefs/app_prefs.dart';
import 'package:onosendai/core/prefs/bookmarked_items_prefs.dart';
import 'package:onosendai/core/prefs/current_user_prefs.dart';
import 'package:onosendai/features/boot/presentation/boot_glitch.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/login/presentation/login_dialog.dart';
import 'package:onosendai/features/login/presentation/riverpod/login_providers.dart';
import 'package:onosendai/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:onosendai/features/notifications/presentation/riverpod/notifications_providers.dart';
import 'package:onosendai/main.dart';

class _LoadedFeedRepository implements FeedRepository {
  int fetchCalls = 0;

  @override
  Future<List<Post>> fetchCached({int limit = 20}) async => const [];

  @override
  Future<PagedResult<Post>> fetch({int limit = 20, String? cursor}) async {
    fetchCalls += 1;
    return const PagedResult(data: [], cursor: null);
  }

  @override
  Future<List<Reply>> fetchCachedReplies(
    String postId, {
    int limit = 20,
  }) async => const [];

  @override
  Future<PagedResult<Reply>> fetchReplies(
    String postId, {
    int limit = 20,
    String? cursor,
  }) async => const PagedResult(data: [], cursor: null);

  @override
  Future<void> deletePost(String postId) async {}

  @override
  Future<void> deleteReply(String replyId) async {}
}

class _LoadedNotificationsRepository implements NotificationsRepository {
  @override
  Future<PagedResult<Notification>> fetch({
    int limit = 20,
    String? cursor,
  }) async => const PagedResult(data: [], cursor: null);
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

class _ContainerAuthTokenProvider implements AuthTokenProvider {
  final ProviderContainer Function() _container;

  _ContainerAuthTokenProvider(this._container);

  @override
  Future<String?> getToken() async =>
      _container().read(authTokensProvider).valueOrNull?.idToken;

  @override
  Future<String?> getRefreshToken() async =>
      _container().read(authTokensProvider).valueOrNull?.refreshToken;

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
    'boot animation mounts app and starts feed fetch before it finishes',
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
      final feedRepository = _LoadedFeedRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tokenStorageProvider.overrideWithValue(storage),
            appPrefsProvider.overrideWithValue(_MemoryAppPrefs()),
            feedRepositoryProvider.overrideWithValue(feedRepository),
            notificationsRepositoryProvider.overrideWithValue(
              _LoadedNotificationsRepository(),
            ),
          ],
          child: const GlitchBootAnimation(
            duration: Duration(milliseconds: 1500),
            child: MainApp(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(storage.reads, 1);
      expect(feedRepository.fetchCalls, 1);
      expect(find.byType(AppUI), findsOneWidget);
      expect(find.byType(Image), findsWidgets);

      await tester.pump(const Duration(milliseconds: 1));
    },
  );

  testWidgets('mobile cold launch with stored tokens opens the app', (
    tester,
  ) async {
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
          notificationsRepositoryProvider.overrideWithValue(
            _LoadedNotificationsRepository(),
          ),
        ],
        child: const MainApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(storage.reads, 1);
    expect(find.byType(AppUI), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(LoginDialog), findsNothing);
  });

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
            'data': {'idToken': 'new-id-token', 'rtdbToken': 'new-rtdb-token'},
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

  test('login fetches current user and stores profile in prefs', () async {
    final prefs = _MemoryAppPrefs();
    final storage = _MemoryTokenStorage(null);
    final requests = <String>[];
    late final ProviderContainer container;

    final client = CyberspaceClient(
      authTokenProvider: _ContainerAuthTokenProvider(() => container),
      httpClient: MockClient((request) async {
        requests.add('${request.method} ${request.url.path}');

        if (request.url.path == '/v1/auth/login') {
          expect(request.method, 'POST');
          expect(jsonDecode(request.body), {
            'email': 'case@ono.test',
            'password': 'correct-horse',
          });

          return http.Response(
            jsonEncode({
              'data': {
                'idToken': 'id-token',
                'refreshToken': 'refresh-token',
                'rtdbToken': 'rtdb-token',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (request.url.path == '/v1/users/me') {
          expect(request.method, 'GET');
          expect(request.headers['Authorization'], 'Bearer id-token');

          return http.Response(
            jsonEncode({
              'data': {
                'userId': 'user-1',
                'username': 'case',
                'profilePictureUrl': 'https://example.test/avatar.png',
                'bio': 'Terminal poet',
                'pinnedPostId': 'post-1',
                'websiteUrl': 'https://example.test',
                'websiteName': 'Example',
                'locationName': 'The grid',
                'createdAt': '2026-04-30T12:34:56.000Z',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (request.url.path == '/v1/bookmarks') {
          expect(request.method, 'GET');
          expect(request.headers['Authorization'], 'Bearer id-token');
          expect(request.url.queryParameters['limit'], '20');

          return http.Response(
            jsonEncode({
              'data': {
                'data': [
                  {
                    'bookmarkId': 'bookmark-post-1',
                    'type': 'post',
                    'postId': 'post-1',
                    'createdAt': '2026-04-30T12:35:56.000Z',
                  },
                  {
                    'bookmarkId': 'bookmark-reply-1',
                    'type': 'reply',
                    'replyId': 'reply-1',
                    'createdAt': '2026-04-30T12:36:56.000Z',
                  },
                  {
                    'bookmarkId': 'bookmark-post-2',
                    'type': 'post',
                    'postId': 'post-2',
                  },
                ],
                'cursor': null,
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        return http.Response(
          jsonEncode({
            'error': {'code': 'not_found', 'message': 'Not found'},
          }),
          404,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    container = ProviderContainer(
      overrides: [
        appPrefsProvider.overrideWithValue(prefs),
        tokenStorageProvider.overrideWithValue(storage),
        cyberspaceClientProvider.overrideWithValue(client),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(loginNotifierProvider.notifier)
        .login(email: 'case@ono.test', password: 'correct-horse');

    expect(requests, [
      'POST /v1/auth/login',
      'GET /v1/users/me',
      'GET /v1/bookmarks',
    ]);
    expect(storage.tokens?.idToken, 'id-token');

    final stored = await prefs.getString(currentUserProfilePrefsKey);
    expect(stored, isNotNull);

    final storedJson = jsonDecode(stored!) as Map<String, dynamic>;
    expect(storedJson['userId'], 'user-1');
    expect(storedJson['username'], 'case');
    expect(storedJson['profilePictureUrl'], 'https://example.test/avatar.png');
    expect(storedJson['createdAt'], '2026-04-30T12:34:56.000Z');

    final bookmarkedPosts = (await prefs.getStringList(
      bookmarkedPostsPrefsKey,
    ))!.map((value) => jsonDecode(value) as Map<String, dynamic>).toList();
    expect(bookmarkedPosts, [
      {'bookmarkId': 'bookmark-post-1', 'postId': 'post-1'},
      {'bookmarkId': 'bookmark-post-2', 'postId': 'post-2'},
    ]);

    final bookmarkedReplies = (await prefs.getStringList(
      bookmarkedRepliesPrefsKey,
    ))!.map((value) => jsonDecode(value) as Map<String, dynamic>).toList();
    expect(bookmarkedReplies, [
      {'bookmarkId': 'bookmark-reply-1', 'replyId': 'reply-1'},
    ]);
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
