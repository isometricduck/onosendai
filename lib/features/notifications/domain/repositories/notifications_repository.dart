import 'package:cyberspace_client/cyberspace_client.dart';

abstract class NotificationsRepository {
  Future<PagedResult<Notification>> fetch({int limit = 20, String? cursor});
}
