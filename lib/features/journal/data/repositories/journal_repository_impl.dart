import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:onosendai/features/journal/domain/repositories/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  final CyberspaceClient _client;

  JournalRepositoryImpl(this._client);

  @override
  Future<PagedResult<Note>> fetch({int limit = 20, String? cursor}) =>
      _client.notes.list(limit: limit, cursor: cursor);

  @override
  Future<void> delete(String noteId) => _client.notes.delete(noteId);
}
