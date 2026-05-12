import 'package:drift/drift.dart';

@DataClassName('JournalNote')
class JournalNotesTable extends Table {
  @override
  String get tableName => 'journal_notes';

  TextColumn get noteId => text()();
  TextColumn get content => text()();
  TextColumn get topics => text()(); // JSON-encoded List<String>
  IntColumn get revision => integer()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  BoolColumn get deleted => boolean()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {noteId};
}
