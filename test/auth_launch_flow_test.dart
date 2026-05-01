import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/auth/secure_storage_token_storage.dart';
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
            appPrefsProvider.overrideWithValue(_MemoryAppPrefs()),
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
