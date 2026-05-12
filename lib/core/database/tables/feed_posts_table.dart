import 'package:drift/drift.dart';

@DataClassName('FeedPost')
class FeedPostsTable extends Table {
  @override
  String get tableName => 'feed_posts';

  TextColumn get postId => text()();
  TextColumn get authorId => text()();
  TextColumn get authorUsername => text()();
  TextColumn get content => text()();
  TextColumn get topics => text()(); // JSON-encoded List<String>
  IntColumn get repliesCount => integer()();
  IntColumn get bookmarksCount => integer()();
  BoolColumn get isPublic => boolean()();
  BoolColumn get isNsfw => boolean()();
  TextColumn get attachments => text()(); // JSON-encoded List
  BoolColumn get hasAudioAttachment => boolean()();
  TextColumn get audioAttachmentGenre => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get deleted => boolean()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {postId};
}
