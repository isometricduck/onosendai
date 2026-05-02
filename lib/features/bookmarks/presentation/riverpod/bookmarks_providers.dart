import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/features/bookmarks/domain/entities/bookmarks_state.dart';

final bookmarksNotifierProvider =
    AsyncNotifierProvider<BookmarksNotifier, BookmarksState>(
      BookmarksNotifier.new,
    );

class BookmarksNotifier extends AsyncNotifier<BookmarksState> {
  @override
  Future<BookmarksState> build() async {
    final prefs = ref.read(bookmarkedItemsPrefsProvider);
    final client = ref.read(cyberspaceClientProvider);

    final postRefs = await prefs.getBookmarkedPosts();
    final replyRefs = await prefs.getBookmarkedReplies();

    final posts = await Future.wait([
      for (final ref in postRefs) client.posts.get(ref.postId),
    ]);
    final replies = await Future.wait([
      for (final ref in replyRefs) client.replies.get(ref.replyId),
    ]);

    return BookmarksState(posts: posts, replies: replies);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
