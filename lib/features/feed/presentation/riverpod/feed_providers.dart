import 'dart:async';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/database_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:onosendai/features/feed/domain/entities/feed_state.dart';
import 'package:onosendai/features/feed/domain/entities/post_detail_state.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';
import 'package:onosendai/features/feed/domain/usecases/delete_post_usecase.dart';
import 'package:onosendai/features/feed/domain/usecases/delete_reply_usecase.dart';
import 'package:onosendai/features/feed/domain/usecases/fetch_feed_usecase.dart';
import 'package:onosendai/features/feed/domain/usecases/fetch_post_replies_usecase.dart';
import 'package:onosendai/features/notifications/presentation/riverpod/notifications_providers.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepositoryImpl(
    ref.read(cyberspaceClientProvider),
    ref.read(appDatabaseProvider),
  );
});

final fetchFeedUseCaseProvider = Provider<FetchFeedUseCase>((ref) {
  return FetchFeedUseCase(ref.read(feedRepositoryProvider));
});

final fetchPostRepliesUseCaseProvider = Provider<FetchPostRepliesUseCase>((
  ref,
) {
  return FetchPostRepliesUseCase(ref.read(feedRepositoryProvider));
});

final deletePostUseCaseProvider = Provider<DeletePostUseCase>((ref) {
  return DeletePostUseCase(ref.read(feedRepositoryProvider));
});

final deleteReplyUseCaseProvider = Provider<DeleteReplyUseCase>((ref) {
  return DeleteReplyUseCase(ref.read(feedRepositoryProvider));
});

final currentUserProfileProvider = FutureProvider<UserProfile>((ref) {
  return ref.read(cyberspaceClientProvider).users.getMe();
});

final feedNotifierProvider = AsyncNotifierProvider<FeedNotifier, FeedState>(
  FeedNotifier.new,
);

final postDetailNotifierProvider =
    AsyncNotifierProvider.family<PostDetailNotifier, PostDetailState, Post>(
      PostDetailNotifier.new,
    );

class FeedNotifier extends AsyncNotifier<FeedState> {
  @override
  Future<FeedState> build() async {
    final useCase = ref.read(fetchFeedUseCaseProvider);

    final cached = await useCase.cached();
    if (cached.isNotEmpty) {
      state = AsyncData(FeedState(posts: cached));
    }

    _refreshNotificationsSoon();
    final page = await useCase();
    return FeedState(posts: page.data, nextCursor: page.cursor);
  }

  Future<void> refresh() async {
    final previous = state;
    state = const AsyncLoading<FeedState>().copyWithPrevious(previous);
    final next = await AsyncValue.guard(() async {
      final notificationsRefresh = _refreshNotifications();
      final page = await ref.read(fetchFeedUseCaseProvider)();
      await notificationsRefresh;
      return FeedState(posts: page.data, nextCursor: page.cursor);
    });
    state = next.copyWithPrevious(previous);
  }

  void _refreshNotificationsSoon() {
    unawaited(
      Future<void>.delayed(Duration.zero, () async {
        await _refreshNotifications();
      }),
    );
  }

  Future<void> _refreshNotifications() async {
    try {
      final notificationsRefresh = ref.refresh(
        notificationsNotifierProvider.future,
      );
      await notificationsRefresh;
    } catch (_) {
      // Keep feed loading independent from notification fetch failures.
    }
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

  Future<void> deletePost(String postId) async {
    await ref.read(deletePostUseCaseProvider)(postId);
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

class PostDetailNotifier extends FamilyAsyncNotifier<PostDetailState, Post> {
  static const _pageSize = 20;

  @override
  Future<PostDetailState> build(Post post) async {
    final useCase = ref.read(fetchPostRepliesUseCaseProvider);

    final cached = await useCase.cached(post.postId, limit: _pageSize);
    if (cached.isNotEmpty) {
      state = AsyncData(PostDetailState(post: post, replies: cached));
    }

    final page = await useCase.call(post.postId, limit: _pageSize);
    return PostDetailState(
      post: post,
      replies: page.data,
      nextCursor: page.cursor,
    );
  }

  Future<void> refresh({bool fetchPost = false}) async {
    final currentPost = arg;
    final previous = state;
    state = const AsyncLoading<PostDetailState>().copyWithPrevious(previous);
    final next = await AsyncValue.guard(() async {
      final post = fetchPost
          ? await ref
                .read(cyberspaceClientProvider)
                .posts
                .get(currentPost.postId)
          : currentPost;
      final page = await ref
          .read(fetchPostRepliesUseCaseProvider)
          .call(post.postId, limit: _pageSize);
      return PostDetailState(
        post: post,
        replies: page.data,
        nextCursor: page.cursor,
      );
    });
    state = next.copyWithPrevious(previous);
  }

  Future<void> createReply(String content) async {
    await ref
        .read(cyberspaceClientProvider)
        .replies
        .create(postId: arg.postId, content: content);
    await refresh(fetchPost: true);
    ref.invalidate(feedNotifierProvider);
  }

  Future<void> deleteReply(String replyId) async {
    await ref.read(deleteReplyUseCaseProvider)(replyId);
    await refresh(fetchPost: true);
    ref.invalidate(feedNotifierProvider);
  }

  Future<void> deletePost() async {
    await ref.read(deletePostUseCaseProvider)(arg.postId);
    await ref.read(bookmarkedItemsPrefsProvider).removePostBookmark(arg.postId);
    ref.invalidate(feedNotifierProvider);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(fetchPostRepliesUseCaseProvider)
          .call(
            current.post.postId,
            cursor: current.nextCursor,
            limit: _pageSize,
          );
      state = AsyncData(
        current.copyWith(
          replies: [...current.replies, ...page.data],
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
