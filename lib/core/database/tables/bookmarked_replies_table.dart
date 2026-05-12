import 'package:drift/drift.dart';

@DataClassName('BookmarkedReply')
class BookmarkedRepliesTable extends Table {
  @override
  String get tableName => 'bookmarked_replies';

  TextColumn get bookmarkId => text()();
  TextColumn get replyId => text()();
  TextColumn get postId => text()();
  TextColumn get parentReplyId => text().nullable()();
  TextColumn get authorId => text()();
  TextColumn get authorUsername => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get deleted => boolean()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {replyId};
}
