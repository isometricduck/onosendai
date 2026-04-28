import 'package:cyberspace_client/cyberspace_client.dart';

abstract class JournalRepository {
  Future<PagedResult<Note>> fetch({int limit = 20, String? cursor});

  Future<void> delete(String noteId);
}
