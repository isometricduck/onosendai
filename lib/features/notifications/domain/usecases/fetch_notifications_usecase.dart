import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:onosendai/features/notifications/domain/repositories/notifications_repository.dart';

class FetchNotificationsUseCase {
  final NotificationsRepository _repo;

  FetchNotificationsUseCase(this._repo);

  Future<PagedResult<Notification>> call({String? cursor, int limit = 20}) {
    return _repo.fetch(cursor: cursor, limit: limit);
  }
}
