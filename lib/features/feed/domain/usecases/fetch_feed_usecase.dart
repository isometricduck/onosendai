import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';

class FetchFeedUseCase {
  final FeedRepository _repo;

  FetchFeedUseCase(this._repo);

  Future<PagedResult<Post>> call({String? cursor, int limit = 20}) =>
      _repo.fetch(cursor: cursor, limit: limit);
}
