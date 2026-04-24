import 'package:cyberspace_client/cyberspace_client.dart';

class FeedState {
  final List<Post> posts;
  final String? nextCursor;
  final bool isLoadingMore;

  const FeedState({
    this.posts = const [],
    this.nextCursor,
    this.isLoadingMore = false,
  });

  bool get hasMore => nextCursor != null;

  FeedState copyWith({
    List<Post>? posts,
    String? nextCursor,
    bool clearCursor = false,
    bool? isLoadingMore,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
