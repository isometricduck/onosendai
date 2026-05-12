import 'dart:convert';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:drift/drift.dart';
import 'package:onosendai/core/database/app_database.dart';
import 'package:onosendai/core/prefs/bookmarked_items_prefs.dart';
import 'package:onosendai/features/bookmarks/domain/entities/bookmarks_state.dart';
import 'package:onosendai/features/bookmarks/domain/repositories/bookmarks_repository.dart';

class BookmarksRepositoryImpl implements BookmarksRepository {
  final CyberspaceClient _client;
  final AppDatabase _db;
  final BookmarkedItemsPrefs _prefs;

  BookmarksRepositoryImpl(this._client, this._db, this._prefs);

  @override
  Future<BookmarksState> fetchCached() async {
    final postRows = await _db.managers.bookmarkedPostsTable
        .orderBy((o) => o.createdAt.desc())
        .get();
    final replyRows = await _db.managers.bookmarkedRepliesTable
        .orderBy((o) => o.createdAt.desc())
        .get();
    return BookmarksState(
      posts: postRows.map(_toPost).toList(),
      replies: replyRows.map(_toReply).toList(),
    );
  }

  @override
  Future<BookmarksState> fetch() async {
    final bookmarkPage = await _client.bookmarks.list(limit: 50);
    final bookmarks = bookmarkPage.data;

    await _prefs.setBookmarks(bookmarks);

    final postBookmarks = bookmarks
        .where((b) => b.type == BookmarkType.post && b.postId != null)
        .toList();
    final replyBookmarks = bookmarks
        .where((b) => b.type == BookmarkType.reply && b.replyId != null)
        .toList();

    final posts = await Future.wait(
      postBookmarks.map((b) => _client.posts.get(b.postId!)),
    );
    final replies = await Future.wait(
      replyBookmarks.map((b) => _client.replies.get(b.replyId!)),
    );

    final postBookmarkIds = {
      for (final b in postBookmarks) b.postId!: b.bookmarkId,
    };
    final replyBookmarkIds = {
      for (final b in replyBookmarks) b.replyId!: b.bookmarkId,
    };
    final now = DateTime.now();

    await _db.transaction(() async {
      await (_db.delete(_db.bookmarkedPostsTable)).go();
      await (_db.delete(_db.bookmarkedRepliesTable)).go();

      if (posts.isNotEmpty) {
        await _db.managers.bookmarkedPostsTable.bulkCreate(
          (o) => posts.map(
            (p) => o(
              bookmarkId: postBookmarkIds[p.postId] ?? '',
              postId: p.postId,
              authorId: p.authorId,
              authorUsername: p.authorUsername,
              content: p.content,
              topics: jsonEncode(p.topics),
              repliesCount: p.repliesCount,
              bookmarksCount: p.bookmarksCount,
              isPublic: p.isPublic,
              isNsfw: p.isNSFW,
              attachments: jsonEncode(p.attachments),
              hasAudioAttachment: p.hasAudioAttachment,
              audioAttachmentGenre: p.audioAttachmentGenre,
              createdAt: p.createdAt,
              deleted: p.deleted,
              cachedAt: now,
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      if (replies.isNotEmpty) {
        await _db.managers.bookmarkedRepliesTable.bulkCreate(
          (o) => replies.map(
            (r) => o(
              bookmarkId: replyBookmarkIds[r.replyId] ?? '',
              replyId: r.replyId,
              postId: r.postId,
              parentReplyId: Value(r.parentReplyId),
              authorId: r.authorId,
              authorUsername: r.authorUsername,
              content: r.content,
              createdAt: r.createdAt,
              deleted: r.deleted,
              cachedAt: now,
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });

    return BookmarksState(posts: posts, replies: replies);
  }

  Post _toPost(BookmarkedPost row) => Post(
    postId: row.postId,
    authorId: row.authorId,
    authorUsername: row.authorUsername,
    content: row.content,
    topics: (jsonDecode(row.topics) as List).cast<String>(),
    repliesCount: row.repliesCount,
    bookmarksCount: row.bookmarksCount,
    isPublic: row.isPublic,
    isNSFW: row.isNsfw,
    attachments: jsonDecode(row.attachments) as List,
    hasAudioAttachment: row.hasAudioAttachment,
    audioAttachmentGenre: row.audioAttachmentGenre,
    createdAt: row.createdAt,
    deleted: row.deleted,
  );

  Reply _toReply(BookmarkedReply row) => Reply(
    replyId: row.replyId,
    postId: row.postId,
    parentReplyId: row.parentReplyId,
    authorId: row.authorId,
    authorUsername: row.authorUsername,
    content: row.content,
    createdAt: row.createdAt,
    deleted: row.deleted,
  );
}
