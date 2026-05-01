import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';

class DeleteReplyUseCase {
  final FeedRepository _repo;

  DeleteReplyUseCase(this._repo);

  Future<void> call(String replyId) => _repo.deleteReply(replyId);
}
