import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/widgets/error_snackbar.dart';
import 'package:onosendai/features/feed/domain/entities/feed_state.dart';
import 'package:onosendai/features/feed/presentation/pages/post_detail_page.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/feed/presentation/widgets/post_card.dart';
import 'package:onosendai/features/profiles/presentation/riverpod/profile_providers.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class UserPostsPage extends ConsumerStatefulWidget {
  final String username;

  const UserPostsPage({super.key, required this.username});

  @override
  ConsumerState<UserPostsPage> createState() => _UserPostsPageState();
}

class _UserPostsPageState extends ConsumerState<UserPostsPage> {
  final _scrollController = ScrollController();
  static const _loadMoreThreshold = 400.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      ref.read(userPostsNotifierProvider(widget.username).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final postsAsync = ref.watch(userPostsNotifierProvider(widget.username));

    ref.listen(userPostsNotifierProvider(widget.username), (_, next) {
      if (!next.hasError || next.isLoading) return;
      showErrorSnackBar(context, _errorMessage(next.error!));
    });

    final body = ColoredBox(
      color: theme.pageBackground,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: postsAsync.when(
              skipError: true,
              loading: () => const _CenteredSpinner(),
              error: (_, _) => const SizedBox.shrink(),
              data: (state) => _UserPostsList(
                username: widget.username,
                state: state,
                scrollController: _scrollController,
                showInlineHeader: !isMobile,
                onRefresh: () => ref
                    .read(userPostsNotifierProvider(widget.username).notifier)
                    .refresh(),
                onDeletePost: (post) async {
                  await ref
                      .read(userPostsNotifierProvider(widget.username).notifier)
                      .deletePost(post.postId);
                  ref.invalidate(feedNotifierProvider);
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
          'POSTS',
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

class _UserPostsList extends StatelessWidget {
  final String username;
  final FeedState state;
  final ScrollController scrollController;
  final bool showInlineHeader;
  final Future<void> Function() onRefresh;
  final Future<void> Function(Post post) onDeletePost;

  const _UserPostsList({
    required this.username,
    required this.state,
    required this.scrollController,
    required this.showInlineHeader,
    required this.onRefresh,
    required this.onDeletePost,
  });

  @override
  Widget build(BuildContext context) {
    void openPost(Post post, {bool initiallyReplying = false}) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              PostDetailPage(post: post, initiallyReplying: initiallyReplying),
        ),
      );
    }

    if (state.posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            if (showInlineHeader) _InlineHeader(username: username),
            const SizedBox(height: 120),
            const Center(child: _DimmedText('No posts yet.')),
          ],
        ),
      );
    }

    final itemCount = state.posts.length + 1 + (showInlineHeader ? 1 : 0);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          var cursor = 0;

          if (showInlineHeader) {
            if (index == cursor) return _InlineHeader(username: username);
            cursor += 1;
          }

          final postIndex = index - cursor;
          if (postIndex < state.posts.length) {
            final post = state.posts[postIndex];
            return PostCard(
              post: post,
              onDelete: onDeletePost,
              onTap: () => openPost(post),
              onReply: () => openPost(post, initiallyReplying: true),
            );
          }

          if (state.isLoadingMore) return const _InlineSpinner();
          if (state.hasMore) return const SizedBox.shrink();
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: _DimmedText('-- end of posts --')),
          );
        },
      ),
    );
  }
}

class _InlineHeader extends StatelessWidget {
  final String username;

  const _InlineHeader({required this.username});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return Row(
      children: [
        Icon(LucideIcons.messagesSquare, color: theme.headingText),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '@$username posts',
            style: theme.mainFont.copyWith(
              color: theme.headingText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
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

class _InlineSpinner extends StatelessWidget {
  const _InlineSpinner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: context.cyberTheme.actionIcon,
          ),
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
  debugPrint('User posts load error: $error (${error.runtimeType})');
  if (error is CyberspaceApiException) return error.message;
  return 'Something went wrong.';
}
