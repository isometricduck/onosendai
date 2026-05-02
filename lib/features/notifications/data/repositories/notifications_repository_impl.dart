import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:onosendai/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final CyberspaceClient _client;

  NotificationsRepositoryImpl(this._client);

  @override
  Future<PagedResult<Notification>> fetch({int limit = 20, String? cursor}) {
    return _client.notifications.list(limit: limit, cursor: cursor);
  }
}
