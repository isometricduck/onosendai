import 'package:drift/drift.dart';

@DataClassName('PostReply')
class PostRepliesTable extends Table {
  @override
  String get tableName => 'post_replies';

  TextColumn get replyId => text()();
  TextColumn get postId => text()();
  TextColumn get parentReplyId => text().nullable()();
  TextColumn get authorId => text()();
  TextColumn get authorUsername => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get deleted => boolean()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {replyId};
}
