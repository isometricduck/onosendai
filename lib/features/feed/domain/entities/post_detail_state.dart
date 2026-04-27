import 'package:cyberspace_client/cyberspace_client.dart';

class PostDetailState {
  final Post post;
  final List<Reply> replies;
  final String? nextCursor;
  final bool isLoadingMore;

  const PostDetailState({
    required this.post,
    required this.replies,
    this.nextCursor,
    this.isLoadingMore = false,
  });

  bool get hasMore => nextCursor != null;

  PostDetailState copyWith({
    Post? post,
    List<Reply>? replies,
    String? nextCursor,
    bool clearCursor = false,
    bool? isLoadingMore,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      replies: replies ?? this.replies,
      nextCursor: clearCursor ? null : nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
