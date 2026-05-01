import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/auth/secure_storage_token_storage.dart';
import 'package:onosendai/core/auth/token_storage.dart';
import 'package:onosendai/core/navigation/app_shell.dart';
import 'package:onosendai/core/providers/client_provider.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  testWidgets(
    'mobile cold launch uses secure-storage tokens and skips login dialog',
    (tester) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const tokens = AuthTokens(
        idToken: 'id-token',
        refreshToken: 'refresh-token',
        rtdbToken: 'rtdb-token',
      );
      FlutterSecureStorage.setMockInitialValues({
        'auth_tokens': encodeAuthTokens(tokens),
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tokenStorageProvider.overrideWithValue(
              SecureStorageTokenStorage(const FlutterSecureStorage()),
            ),
            feedRepositoryProvider.overrideWithValue(_LoadedFeedRepository()),
          ],
          child: const MainApp(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(LoginDialog), findsNothing);
    },
  );

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
