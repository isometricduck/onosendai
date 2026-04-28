import 'package:onosendai/features/journal/domain/repositories/journal_repository.dart';

class DeleteJournalNoteUseCase {
  final JournalRepository _repo;

  DeleteJournalNoteUseCase(this._repo);

  Future<void> call(String noteId) => _repo.delete(noteId);
}
