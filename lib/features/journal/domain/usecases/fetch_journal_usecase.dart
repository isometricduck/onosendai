import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:onosendai/features/journal/domain/repositories/journal_repository.dart';

class FetchJournalUseCase {
  final JournalRepository _repo;

  FetchJournalUseCase(this._repo);

  Future<List<Note>> cached({int limit = 20}) =>
      _repo.fetchCached(limit: limit);

  Future<PagedResult<Note>> call({String? cursor, int limit = 20}) =>
      _repo.fetch(cursor: cursor, limit: limit);
}
