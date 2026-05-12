import 'dart:convert';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:drift/drift.dart';
import 'package:onosendai/core/database/app_database.dart';
import 'package:onosendai/features/journal/domain/repositories/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  final CyberspaceClient _client;
  final AppDatabase _db;

  JournalRepositoryImpl(this._client, this._db);

  @override
  Future<List<Note>> fetchCached({int limit = 20}) async {
    final rows = await _db.managers.journalNotesTable
        .orderBy((o) => o.createdAt.desc())
        .limit(limit)
        .get();
    return rows.map(_toNote).toList();
  }

  @override
  Future<PagedResult<Note>> fetch({int limit = 20, String? cursor}) async {
    final result = await _client.notes.list(limit: limit, cursor: cursor);
    final now = DateTime.now();
    await _db.managers.journalNotesTable.bulkCreate(
      (o) => result.data.map(
        (n) => o(
          noteId: n.noteId,
          content: n.content,
          topics: jsonEncode(n.topics),
          revision: n.revision,
          createdAt: Value(n.createdAt),
          deleted: n.deleted,
          fetchedAt: now,
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
    return result;
  }

  @override
  Future<void> delete(String noteId) => _client.notes.delete(noteId);

  @override
  Future<void> deleteFromCache(String noteId) =>
      _db.managers.journalNotesTable
          .filter((f) => f.noteId.equals(noteId))
          .delete();

  Note _toNote(JournalNote row) => Note(
    noteId: row.noteId,
    content: row.content,
    topics: (jsonDecode(row.topics) as List).cast<String>(),
    revision: row.revision,
    createdAt: row.createdAt,
    deleted: row.deleted,
  );
}
