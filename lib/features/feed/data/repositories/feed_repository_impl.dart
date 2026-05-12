import 'dart:convert';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:drift/drift.dart';
import 'package:onosendai/core/database/app_database.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final CyberspaceClient _client;
  final AppDatabase _db;

  FeedRepositoryImpl(this._client, this._db);

  @override
  Future<List<Post>> fetchCached({int limit = 20}) async {
    final rows = await _db.managers.feedPostsTable
        .orderBy((o) => o.createdAt.desc())
        .limit(limit)
        .get();
    return rows.map(_toPost).toList();
  }

  Post _toPost(FeedPost row) => Post(
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

  @override
  Future<PagedResult<Post>> fetch({int limit = 20, String? cursor}) async {
    final result = await _client.posts.list(limit: limit, cursor: cursor);
    final now = DateTime.now();
    await _db.managers.feedPostsTable.bulkCreate(
      (o) => result.data.map(
        (p) => o(
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
          fetchedAt: now,
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
    return result;
  }

  @override
  Future<List<Reply>> fetchCachedReplies(String postId, {int limit = 20}) async {
    final rows = await _db.managers.postRepliesTable
        .filter((f) => f.postId.equals(postId))
        .orderBy((o) => o.createdAt.asc())
        .limit(limit)
        .get();
    return rows.map(_toReply).toList();
  }

  @override
  Future<PagedResult<Reply>> fetchReplies(
    String postId, {
    int limit = 20,
    String? cursor,
  }) async {
    final result = await _client.replies.list(postId, limit: limit, cursor: cursor);
    final now = DateTime.now();
    await _db.managers.postRepliesTable.bulkCreate(
      (o) => result.data.map(
        (r) => o(
          replyId: r.replyId,
          postId: r.postId,
          parentReplyId: Value(r.parentReplyId),
          authorId: r.authorId,
          authorUsername: r.authorUsername,
          content: r.content,
          createdAt: r.createdAt,
          deleted: r.deleted,
          fetchedAt: now,
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
    return result;
  }

  Reply _toReply(PostReply row) => Reply(
    replyId: row.replyId,
    postId: row.postId,
    parentReplyId: row.parentReplyId,
    authorId: row.authorId,
    authorUsername: row.authorUsername,
    content: row.content,
    createdAt: row.createdAt,
    deleted: row.deleted,
  );

  @override
  Future<void> deletePost(String postId) => _client.posts.delete(postId);

  @override
  Future<void> deleteReply(String replyId) => _client.replies.delete(replyId);
}
