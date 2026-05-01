import 'package:cyberspace_client/cyberspace_client.dart';

abstract class FeedRepository {
  Future<PagedResult<Post>> fetch({int limit = 20, String? cursor});

  Future<PagedResult<Reply>> fetchReplies(
    String postId, {
    int limit = 20,
    String? cursor,
  });

  Future<void> deleteReply(String replyId);
}
