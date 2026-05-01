import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:onosendai/features/feed/domain/entities/feed_state.dart';
import 'package:onosendai/features/feed/domain/entities/post_detail_state.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';
import 'package:onosendai/features/feed/domain/usecases/delete_reply_usecase.dart';
import 'package:onosendai/features/feed/domain/usecases/fetch_feed_usecase.dart';
import 'package:onosendai/features/feed/domain/usecases/fetch_post_replies_usecase.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepositoryImpl(ref.read(cyberspaceClientProvider));
});

final fetchFeedUseCaseProvider = Provider<FetchFeedUseCase>((ref) {
  return FetchFeedUseCase(ref.read(feedRepositoryProvider));
});

final fetchPostRepliesUseCaseProvider = Provider<FetchPostRepliesUseCase>((
  ref,
) {
  return FetchPostRepliesUseCase(ref.read(feedRepositoryProvider));
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

class PostDetailNotifier extends FamilyAsyncNotifier<PostDetailState, Post> {
  static const _pageSize = 20;

  @override
  Future<PostDetailState> build(Post post) async {
    final page = await ref
        .read(fetchPostRepliesUseCaseProvider)
        .call(post.postId, limit: _pageSize);
    return PostDetailState(
      post: post,
      replies: page.data,
      nextCursor: page.cursor,
    );
  }

  Future<void> refresh({bool fetchPost = false}) async {
    final currentPost = arg;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
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
