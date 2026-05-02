import 'dart:convert';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:onosendai/core/prefs/app_prefs.dart';

const bookmarkedPostsPrefsKey = 'bookmarked_posts';
const bookmarkedRepliesPrefsKey = 'bookmarked_replies';

class BookmarkedItemsPrefs {
  final AppPrefs _prefs;

  const BookmarkedItemsPrefs(this._prefs);

  Future<List<BookmarkedPostRef>> getBookmarkedPosts() async {
    final values = await _prefs.getStringList(bookmarkedPostsPrefsKey);
    if (values == null) return const [];

    return [for (final value in values) ?_decodeBookmarkedPostRef(value)];
  }

  Future<List<BookmarkedReplyRef>> getBookmarkedReplies() async {
    final values = await _prefs.getStringList(bookmarkedRepliesPrefsKey);
    if (values == null) return const [];

    return [for (final value in values) ?_decodeBookmarkedReplyRef(value)];
  }

  Future<void> setBookmarks(Iterable<Bookmark> bookmarks) async {
    final bookmarkedPosts = <String>[];
    final bookmarkedReplies = <String>[];

    for (final bookmark in bookmarks) {
      switch (bookmark.type) {
        case BookmarkType.post:
          final postId = bookmark.postId;
          if (postId == null) continue;
          bookmarkedPosts.add(
            jsonEncode({'bookmarkId': bookmark.bookmarkId, 'postId': postId}),
          );
        case BookmarkType.reply:
          final replyId = bookmark.replyId;
          if (replyId == null) continue;
          bookmarkedReplies.add(
            jsonEncode({'bookmarkId': bookmark.bookmarkId, 'replyId': replyId}),
          );
      }
    }

    await Future.wait([
      _prefs.setStringList(bookmarkedPostsPrefsKey, bookmarkedPosts),
      _prefs.setStringList(bookmarkedRepliesPrefsKey, bookmarkedReplies),
    ]);
  }

  Future<void> addPostBookmark({
    required String bookmarkId,
    required String postId,
  }) async {
    final bookmarks = await getBookmarkedPosts();
    if (bookmarks.any((bookmark) => bookmark.postId == postId)) return;

    await _prefs.setStringList(bookmarkedPostsPrefsKey, [
      ...bookmarks.map(
        (bookmark) => jsonEncode({
          'bookmarkId': bookmark.bookmarkId,
          'postId': bookmark.postId,
        }),
      ),
      jsonEncode({'bookmarkId': bookmarkId, 'postId': postId}),
    ]);
  }

  Future<void> removePostBookmark(String postId) async {
    final bookmarks = await getBookmarkedPosts();
    await _prefs.setStringList(bookmarkedPostsPrefsKey, [
      for (final bookmark in bookmarks)
        if (bookmark.postId != postId)
          jsonEncode({
            'bookmarkId': bookmark.bookmarkId,
            'postId': bookmark.postId,
          }),
    ]);
  }

  Future<void> clear() async {
    await Future.wait([
      _prefs.remove(bookmarkedPostsPrefsKey),
      _prefs.remove(bookmarkedRepliesPrefsKey),
    ]);
  }
}

typedef BookmarkedPostRef = ({String bookmarkId, String postId});
typedef BookmarkedReplyRef = ({String bookmarkId, String replyId});

BookmarkedPostRef? _decodeBookmarkedPostRef(String value) {
  final decoded = jsonDecode(value);
  if (decoded is! Map<String, dynamic>) return null;

  final bookmarkId = decoded['bookmarkId'];
  final postId = decoded['postId'];
  if (bookmarkId is! String || postId is! String) return null;

  return (bookmarkId: bookmarkId, postId: postId);
}

BookmarkedReplyRef? _decodeBookmarkedReplyRef(String value) {
  final decoded = jsonDecode(value);
  if (decoded is! Map<String, dynamic>) return null;

  final bookmarkId = decoded['bookmarkId'];
  final replyId = decoded['replyId'];
  if (bookmarkId is! String || replyId is! String) return null;

  return (bookmarkId: bookmarkId, replyId: replyId);
}
