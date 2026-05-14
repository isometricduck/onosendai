import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/features/feed/domain/entities/feed_state.dart';

final currentUserProfileProvider = FutureProvider<UserProfile>((ref) {
  return ref.read(cyberspaceClientProvider).users.getMe();
});

final userProfileProvider = FutureProvider.family<UserProfile, String>((
  ref,
  username,
) {
  return ref.read(cyberspaceClientProvider).users.get(username);
});

final userPostsNotifierProvider =
    AsyncNotifierProvider.family<UserPostsNotifier, FeedState, String>(
      UserPostsNotifier.new,
    );

class UserPostsNotifier extends FamilyAsyncNotifier<FeedState, String> {
  static const _pageSize = 20;

  @override
  Future<FeedState> build(String username) async {
    final page = await ref
        .read(cyberspaceClientProvider)
        .users
        .listPosts(username, limit: _pageSize);
    return FeedState(posts: page.data, nextCursor: page.cursor);
  }

  Future<void> refresh() async {
    final previous = state;
    state = const AsyncLoading<FeedState>().copyWithPrevious(previous);
    final next = await AsyncValue.guard(() async {
      final page = await ref
          .read(cyberspaceClientProvider)
          .users
          .listPosts(arg, limit: _pageSize);
      return FeedState(posts: page.data, nextCursor: page.cursor);
    });
    state = next.copyWithPrevious(previous);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(cyberspaceClientProvider)
          .users
          .listPosts(arg, limit: _pageSize, cursor: current.nextCursor);
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

  Future<void> deletePost(String postId) async {
    await ref.read(cyberspaceClientProvider).posts.delete(postId);
    await ref.read(bookmarkedItemsPrefsProvider).removePostBookmark(postId);

    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        posts: [
          for (final post in current.posts)
            if (post.postId != postId) post,
        ],
      ),
    );
  }
}
