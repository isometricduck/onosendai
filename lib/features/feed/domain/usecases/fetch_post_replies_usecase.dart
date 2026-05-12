import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';

class FetchPostRepliesUseCase {
  final FeedRepository _repo;

  FetchPostRepliesUseCase(this._repo);

  Future<List<Reply>> cached(String postId, {int limit = 20}) =>
      _repo.fetchCachedReplies(postId, limit: limit);

  Future<PagedResult<Reply>> call(
    String postId, {
    String? cursor,
    int limit = 20,
  }) => _repo.fetchReplies(postId, cursor: cursor, limit: limit);
}
