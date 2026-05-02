import 'dart:convert';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/auth/token_storage.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/core/prefs/app_prefs.dart';
import 'package:onosendai/core/prefs/bookmarked_items_prefs.dart';
import 'package:onosendai/features/feed/presentation/widgets/post_card.dart';

class _MemoryAppPrefs implements AppPrefs {
  final Map<String, Object> _values = {};

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
  @override
  Future<AuthTokens?> read() async => null;

  @override
  Future<void> write(AuthTokens tokens) async {}

  @override
  Future<void> clear() async {}
}

class _NoopAuthTokenProvider implements AuthTokenProvider {
  @override
  Future<String?> getToken() async => 'id-token';

  @override
  Future<String?> getRefreshToken() async => 'refresh-token';

  @override
  Future<void> onTokensRefreshed(RefreshedTokens tokens) async {}

  @override
  Future<void> onUnauthorized() async {}
}

void main() {
  Post buildPost() {
    return Post(
      postId: 'post-1',
      authorId: 'user-1',
      authorUsername: 'case',
      content: 'Save this signal.',
      topics: const [],
      repliesCount: 0,
      bookmarksCount: 0,
      isPublic: true,
      isNSFW: false,
      attachments: const [],
      hasAudioAttachment: false,
      audioAttachmentGenre: '',
      createdAt: DateTime.utc(2026, 4, 30),
      deleted: false,
    );
  }

  testWidgets('save button creates a post bookmark and stores it in prefs', (
    tester,
  ) async {
    final prefs = _MemoryAppPrefs();
    final requests = <String>[];
    final client = CyberspaceClient(
      authTokenProvider: _NoopAuthTokenProvider(),
      httpClient: MockClient((request) async {
        requests.add('${request.method} ${request.url.path}');
        expect(request.method, 'POST');
        expect(request.url.path, '/v1/bookmarks');
        expect(request.headers['Authorization'], 'Bearer id-token');
        expect(jsonDecode(request.body), {'postId': 'post-1', 'type': 'post'});

        return http.Response(
          jsonEncode({
            'data': {'bookmarkId': 'bookmark-post-1'},
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appPrefsProvider.overrideWithValue(prefs),
          tokenStorageProvider.overrideWithValue(_MemoryTokenStorage()),
          cyberspaceClientProvider.overrideWithValue(client),
        ],
        child: MaterialApp(
          home: Scaffold(body: PostCard(post: buildPost())),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byIcon(LucideIcons.bookmark));
    await tester.pumpAndSettle();

    expect(requests, ['POST /v1/bookmarks']);
    final stored = await prefs.getStringList(bookmarkedPostsPrefsKey);
    expect(stored, isNotNull);
    expect(jsonDecode(stored!.single), {
      'bookmarkId': 'bookmark-post-1',
      'postId': 'post-1',
    });
  });

  testWidgets('bookmarked post renders remove action and deletes bookmark', (
    tester,
  ) async {
    final prefs = _MemoryAppPrefs();
    await prefs.setStringList(bookmarkedPostsPrefsKey, [
      jsonEncode({'bookmarkId': 'bookmark-post-1', 'postId': 'post-1'}),
    ]);
    final requests = <String>[];
    final client = CyberspaceClient(
      authTokenProvider: _NoopAuthTokenProvider(),
      httpClient: MockClient((request) async {
        requests.add('${request.method} ${request.url.path}');
        expect(request.method, 'DELETE');
        expect(request.url.path, '/v1/bookmarks/bookmark-post-1');
        expect(request.headers['Authorization'], 'Bearer id-token');

        return http.Response(
          jsonEncode({'data': {}}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appPrefsProvider.overrideWithValue(prefs),
          tokenStorageProvider.overrideWithValue(_MemoryTokenStorage()),
          cyberspaceClientProvider.overrideWithValue(client),
        ],
        child: MaterialApp(
          home: Scaffold(body: PostCard(post: buildPost())),
        ),
      ),
    );

    await tester.pump();

    expect(find.byIcon(LucideIcons.bookmarkMinus), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.bookmarkMinus));
    await tester.pumpAndSettle();

    expect(requests, ['DELETE /v1/bookmarks/bookmark-post-1']);
    expect(await prefs.getStringList(bookmarkedPostsPrefsKey), isEmpty);
    expect(find.byIcon(LucideIcons.bookmark), findsOneWidget);
  });
}
