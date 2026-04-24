import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:onosendai/features/feed/domain/entities/feed_state.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';
import 'package:onosendai/features/feed/domain/usecases/fetch_feed_usecase.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepositoryImpl(ref.read(cyberspaceClientProvider));
});

final fetchFeedUseCaseProvider = Provider<FetchFeedUseCase>((ref) {
  return FetchFeedUseCase(ref.read(feedRepositoryProvider));
});

final feedNotifierProvider =
    AsyncNotifierProvider<FeedNotifier, FeedState>(FeedNotifier.new);

class FeedNotifier extends AsyncNotifier<FeedState> {
  @override
  Future<FeedState> build() async {
    final page = await ref.read(fetchFeedUseCaseProvider)();
    return FeedState(posts: page.data, nextCursor: page.cursor);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final page = await ref.read(fetchFeedUseCaseProvider)();
      return FeedState(posts: page.data, nextCursor: page.cursor);
    });
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(fetchFeedUseCaseProvider)
          .call(cursor: current.nextCursor);
      state = AsyncData(
        current.copyWith(
          posts: [...current.posts, ...page.data],
          nextCursor: page.cursor,
          clearCursor: page.cursor == null,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
      rethrow;
    }
  }
}
