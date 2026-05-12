import 'package:cyberspace_client/cyberspace_client.dart';

abstract class FeedRepository {
  Future<List<Post>> fetchCached({int limit = 20});

  Future<PagedResult<Post>> fetch({int limit = 20, String? cursor});

  Future<List<Reply>> fetchCachedReplies(String postId, {int limit = 20});

  Future<PagedResult<Reply>> fetchReplies(
    String postId, {
    int limit = 20,
    String? cursor,
  });

  Future<void> deletePost(String postId);

  Future<void> deleteReply(String replyId);
}
