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
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(bookmarkedPostsTable);
        await m.createTable(bookmarkedRepliesTable);
      }
      if (from < 3) {
        await m.createTable(journalNotesTable);
      }
      if (from < 4) {
        await m.createTable(postRepliesTable);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'onosendai');
  }
}
