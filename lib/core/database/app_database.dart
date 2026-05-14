import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:onosendai/core/database/tables/bookmarked_posts_table.dart';
import 'package:onosendai/core/database/tables/bookmarked_replies_table.dart';
import 'package:onosendai/core/database/tables/feed_posts_table.dart';
import 'package:onosendai/core/database/tables/journal_notes_table.dart';
import 'package:onosendai/core/database/tables/post_replies_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    FeedPostsTable,
    BookmarkedPostsTable,
    BookmarkedRepliesTable,
    JournalNotesTable,
    PostRepliesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
      }
      await m.createAll();
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'onosendai');
  }
}
