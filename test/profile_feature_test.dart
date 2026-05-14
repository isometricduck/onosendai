import 'dart:convert';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/images/images.dart';
import 'package:onosendai/core/navigation/landscape_shell.dart';
import 'package:onosendai/core/navigation/mobile_shell.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:onosendai/features/notifications/presentation/riverpod/notifications_providers.dart';
import 'package:onosendai/features/profiles/presentation/pages/user_profile_page.dart';
import 'package:onosendai/features/theme/classic/dark_theme.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class _LoadedFeedRepository implements FeedRepository {
  @override
  Future<List<Post>> fetchCached({int limit = 20}) async => const [];

  @override
  Future<PagedResult<Post>> fetch({int limit = 20, String? cursor}) async {
    return const PagedResult(data: [], cursor: null);
  }

  @override
  Future<List<Reply>> fetchCachedReplies(
    String postId, {
    int limit = 20,
  }) async {
    return const [];
  }

  @override
  Future<PagedResult<Reply>> fetchReplies(
    String postId, {
    int limit = 20,
    String? cursor,
  }) async {
    return const PagedResult(data: [], cursor: null);
  }

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
  }) async {
    return const PagedResult(data: [], cursor: null);
  }
}

class _NoopAuthTokenProvider implements AuthTokenProvider {
  @override
  Future<String?> getToken() async => 'id-token';

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<void> onTokensRefreshed(RefreshedTokens tokens) async {}

  @override
  Future<void> onUnauthorized() async {}
}

Widget _wrap(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: AppThemeScope(
      theme: DarkTheme(),
      child: MaterialApp(home: child),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('profile page fetches and renders the current user', (
    tester,
  ) async {
    final requests = <String>[];
    final client = CyberspaceClient(
      authTokenProvider: _NoopAuthTokenProvider(),
      httpClient: MockClient((request) async {
        requests.add('${request.method} ${request.url.path}');

        if (request.url.path == '/v1/users/me') {
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
                'locationLatitude': 12.5,
                'locationLongitude': -45.25,
                'locationName': 'The grid',
                'createdAt': '2026-04-30T12:34:56.000Z',
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

    await tester.pumpWidget(
      _wrap(
        const UserProfilePage(),
        overrides: [cyberspaceClientProvider.overrideWithValue(client)],
      ),
    );
    await tester.pumpAndSettle();

    expect(requests, ['GET /v1/users/me']);
    expect(find.text('@case'), findsOneWidget);
    expect(find.text('Terminal poet'), findsOneWidget);
    expect(find.byType(ShadedNetworkImage), findsOneWidget);
  });

  testWidgets('profile page can fetch and render an arbitrary user', (
    tester,
  ) async {
    final requests = <String>[];
    final client = CyberspaceClient(
      authTokenProvider: _NoopAuthTokenProvider(),
      httpClient: MockClient((request) async {
        requests.add('${request.method} ${request.url.path}');

        if (request.url.path == '/v1/users/molly') {
          return http.Response(
            jsonEncode({
              'data': {
                'userId': 'user-2',
                'username': 'molly',
                'bio': 'Signal hunter',
                'createdAt': '2026-05-01T12:34:56.000Z',
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

    await tester.pumpWidget(
      _wrap(
        const UserProfilePage(username: 'molly'),
        overrides: [cyberspaceClientProvider.overrideWithValue(client)],
      ),
    );
    await tester.pumpAndSettle();

    expect(requests, ['GET /v1/users/molly']);
    expect(find.text('@molly'), findsOneWidget);
    expect(find.text('Signal hunter'), findsOneWidget);
  });

  testWidgets('mobile keeps profile hidden behind the menu', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _wrap(
        const MobileShell(),
        overrides: [
          feedRepositoryProvider.overrideWithValue(_LoadedFeedRepository()),
          notificationsRepositoryProvider.overrideWithValue(
            _LoadedNotificationsRepository(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationDestination), findsNWidgets(5));
    expect(find.text('Profile'), findsNothing);

    await tester.tap(find.byIcon(LucideIcons.menu).last);
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('desktop rail includes profile', (tester) async {
    tester.view
      ..physicalSize = const Size(1280, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _wrap(
        const LandscapeShell(railWidth: 220, extended: true),
        overrides: [
          feedRepositoryProvider.overrideWithValue(_LoadedFeedRepository()),
          notificationsRepositoryProvider.overrideWithValue(
            _LoadedNotificationsRepository(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
