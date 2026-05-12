import 'package:cyberspace_client/cyberspace_client.dart';

abstract class JournalRepository {
  Future<List<Note>> fetchCached({int limit = 20});

  Future<PagedResult<Note>> fetch({int limit = 20, String? cursor});

  Future<void> delete(String noteId);

  Future<void> deleteFromCache(String noteId);
}
