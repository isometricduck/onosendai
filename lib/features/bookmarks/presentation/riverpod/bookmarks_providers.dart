import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/database_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/features/bookmarks/data/repositories/bookmarks_repository_impl.dart';
import 'package:onosendai/features/bookmarks/domain/entities/bookmarks_state.dart';
import 'package:onosendai/features/bookmarks/domain/repositories/bookmarks_repository.dart';
import 'package:onosendai/features/bookmarks/domain/usecases/fetch_bookmarks_usecase.dart';

final bookmarksRepositoryProvider = Provider<BookmarksRepository>((ref) {
  return BookmarksRepositoryImpl(
    ref.read(cyberspaceClientProvider),
    ref.read(appDatabaseProvider),
    ref.read(bookmarkedItemsPrefsProvider),
  );
});

final fetchBookmarksUseCaseProvider = Provider<FetchBookmarksUseCase>((ref) {
  return FetchBookmarksUseCase(ref.read(bookmarksRepositoryProvider));
});

final bookmarksNotifierProvider =
    AsyncNotifierProvider<BookmarksNotifier, BookmarksState>(
      BookmarksNotifier.new,
    );

class BookmarksNotifier extends AsyncNotifier<BookmarksState> {
  @override
  Future<BookmarksState> build() async {
    final useCase = ref.read(fetchBookmarksUseCaseProvider);

    final cached = await useCase.cached();
    if (!cached.isEmpty) {
      state = AsyncData(cached);
    }

    return useCase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(fetchBookmarksUseCaseProvider)(),
    );
  }
}
