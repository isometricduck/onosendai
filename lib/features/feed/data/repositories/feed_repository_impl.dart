import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final CyberspaceClient _client;

  FeedRepositoryImpl(this._client);

  @override
  Future<PagedResult<Post>> fetch({int limit = 20, String? cursor}) =>
      _client.posts.list(limit: limit, cursor: cursor);

  @override
  Future<PagedResult<Reply>> fetchReplies(
    String postId, {
    int limit = 20,
    String? cursor,
  }) => _client.replies.list(postId, limit: limit, cursor: cursor);

  @override
  Future<void> deletePost(String postId) => _client.posts.delete(postId);

  @override
  Future<void> deleteReply(String replyId) => _client.replies.delete(replyId);
}
