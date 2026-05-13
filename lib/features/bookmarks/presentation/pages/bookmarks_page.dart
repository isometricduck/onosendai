import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/core/widgets/error_snackbar.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/bookmarks/domain/entities/bookmarks_state.dart';
import 'package:onosendai/features/bookmarks/presentation/riverpod/bookmarks_providers.dart';
import 'package:onosendai/features/feed/presentation/pages/post_detail_page.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/feed/presentation/riverpod/selected_post_provider.dart';
import 'package:onosendai/features/feed/presentation/widgets/post_card.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.cyberTheme;
    final bookmarksAsync = ref.watch(bookmarksNotifierProvider);
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    ref.listen(bookmarksNotifierProvider, (_, next) {
      if (!next.hasError || next.isLoading) return;
      showErrorSnackBar(context, _errorMessage(next.error!));
    });

    final body = ColoredBox(
      color: theme.pageBackground,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: bookmarksAsync.when(
              skipError: true,
              loading: () => const _CenteredSpinner(),
              error: (_, _) => const SizedBox.shrink(),
              data: (state) => _BookmarksList(
                state: state,
                showInlineHeader: !isMobile,
                onRefresh: () =>
                    ref.read(bookmarksNotifierProvider.notifier).refresh(),
                onDeletePost: (post) async {
                  await ref.read(deletePostUseCaseProvider)(post.postId);
                  await ref
                      .read(bookmarkedItemsPrefsProvider)
                      .removePostBookmark(post.postId);
                  ref.invalidate(feedNotifierProvider);
                  await ref.read(bookmarksNotifierProvider.notifier).refresh();
                },
              ),
            ),
          ),
        ),
      ),
    );

    if (!isMobile) {
      return Scaffold(backgroundColor: theme.pageBackground, body: body);
    }

    return Scaffold(
      backgroundColor: theme.pageBackground,
      appBar: AppBar(
        backgroundColor: theme.pageBackground,
        foregroundColor: theme.headingText,
        surfaceTintColor: theme.pageBackground,
        title: Text(
          'BOOKMARKS',
          style: theme.mainFont.copyWith(
            color: theme.headingText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: body,
    );
  }
}

class _BookmarksList extends ConsumerWidget {
  final BookmarksState state;
  final bool showInlineHeader;
  final Future<void> Function() onRefresh;
  final Future<void> Function(Post post) onDeletePost;

  const _BookmarksList({
    required this.state,
    required this.showInlineHeader,
    required this.onRefresh,
    required this.onDeletePost,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    void openPost(Post post, {bool initiallyReplying = false}) {
      if (isMobile) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PostDetailPage(
              post: post,
              initiallyReplying: initiallyReplying,
            ),
          ),
        );
      } else {
        ref.read(selectedPostProvider.notifier).state = (
          post,
          initiallyReplying,
        );
      }
    }

    if (state.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            if (showInlineHeader) const _InlineHeader(),
            const SizedBox(height: 120),
            const Center(child: _DimmedText('No bookmarks yet.')),
          ],
        ),
      );
    }

    final itemCount =
        (showInlineHeader ? 1 : 0) +
        1 +
        state.posts.length +
        1 +
        state.replies.length;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          var cursor = 0;

          if (showInlineHeader) {
            if (index == cursor) return const _InlineHeader();
            cursor += 1;
          }

          if (index == cursor) return _SectionHeader(label: 'POSTS');
          cursor += 1;

          final postIndex = index - cursor;
          if (postIndex >= 0 && postIndex < state.posts.length) {
            final post = state.posts[postIndex];
            return PostCard(
              post: post,
              onDelete: onDeletePost,
              onTap: () => openPost(post),
              onReply: () => openPost(post, initiallyReplying: true),
            );
          }
          cursor += state.posts.length;

          if (index == cursor) return _SectionHeader(label: 'REPLIES');
          cursor += 1;

          final replyIndex = index - cursor;
          final reply = state.replies[replyIndex];
          return _BookmarkedReplyCard(reply: reply);
        },
      ),
    );
  }
}

class _BookmarkedReplyCard extends StatelessWidget {
  final Reply reply;

  const _BookmarkedReplyCard({required this.reply});

  @override
  Widget build(BuildContext context) {
    return ReplyCard(reply: reply);
  }
}

class _InlineHeader extends StatelessWidget {
  const _InlineHeader();

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return Row(
      children: [
        Icon(LucideIcons.bookmark, color: theme.headingText),
        const SizedBox(width: 10),
        Text(
          'Bookmarks',
          style: theme.mainFont.copyWith(
            color: theme.headingText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return Text(
      label,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        color: theme.metaText,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _CenteredSpinner extends StatelessWidget {
  const _CenteredSpinner();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: context.cyberTheme.actionIcon,
        ),
      ),
    );
  }
}

class _DimmedText extends StatelessWidget {
  final String text;

  const _DimmedText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.cyberTheme.mainFont);
  }
}

String _errorMessage(Object error) {
  debugPrint('Bookmarks load error: $error (${error.runtimeType})');
  if (error is CyberspaceApiException) return error.message;
  return 'Something went wrong.';
}
