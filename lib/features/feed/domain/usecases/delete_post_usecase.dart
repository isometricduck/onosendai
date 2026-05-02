import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';

class DeletePostUseCase {
  final FeedRepository _repo;

  DeletePostUseCase(this._repo);

  Future<void> call(String postId) => _repo.deletePost(postId);
}
