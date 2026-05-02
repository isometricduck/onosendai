import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/features/login/data/repositories/auth_repository_impl.dart';
import 'package:onosendai/features/login/domain/repositories/auth_repository.dart';
import 'package:onosendai/features/login/domain/usecases/login_usecase.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(cyberspaceClientProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final loginNotifierProvider = AsyncNotifierProvider<LoginNotifier, void>(
  LoginNotifier.new,
);

class LoginNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> login({required String email, required String password}) async {
    ref.read(authMessageProvider.notifier).state = null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final tokens = await ref
          .read(loginUseCaseProvider)
          .call(email: email, password: password);
      await ref.read(authTokensProvider.notifier).set(tokens);
      try {
        final client = ref.read(cyberspaceClientProvider);
        final profile = await client.users.getMe();
        final bookmarks = await client.bookmarks.list();

        await Future.wait([
          ref.read(currentUserPrefsProvider).setProfile(profile),
          ref.read(bookmarkedItemsPrefsProvider).setBookmarks(bookmarks.data),
        ]);
      } catch (_) {
        await ref.read(authTokensProvider.notifier).clear();
        rethrow;
      }
    });
  }
}
