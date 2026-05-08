import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/features/theme/theme.dart';
import 'package:onosendai/features/bookmarks/domain/entities/bookmarks_state.dart';
import 'package:onosendai/features/bookmarks/presentation/riverpod/bookmarks_providers.dart';
import 'package:onosendai/features/feed/domain/entities/feed_state.dart';
import 'package:onosendai/features/feed/presentation/pages/post_detail_page.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/feed/presentation/widgets/eink_post_card.dart';
import 'package:onosendai/features/feed/presentation/widgets/post_card.dart';

typedef EinkDestinationSheetBuilder =
    Widget Function(BuildContext context, VoidCallback hideOverlay);

enum EinkFeedSource { feed, bookmarks }

class EinkFeedPage extends ConsumerStatefulWidget {
  final EinkFeedSource source;
  final EinkDestinationSheetBuilder? destinationSheetBuilder;

  const EinkFeedPage({
    super.key,
    this.source = EinkFeedSource.feed,
    this.destinationSheetBuilder,
  });

  @override
  ConsumerState<EinkFeedPage> createState() => _EinkFeedPageState();
}

class _EinkFeedPageState extends ConsumerState<EinkFeedPage> {
  static const _previousTapZoneEnd = 0.35;
  static const _overlayTapZoneEnd = 0.65;

  var _selectedIndex = 0;
  var _overlayVisible = false;
  var _bookmarkedPostIds = <String>{};

  String get _title {
    return switch (widget.source) {
      EinkFeedSource.feed => 'Feed',
      EinkFeedSource.bookmarks => 'Bookmarks',
    };
  }

  @override
  void didUpdateWidget(covariant EinkFeedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source == widget.source) return;
    _selectedIndex = 0;
    _overlayVisible = false;
  }

  @override
  void initState() {
    super.initState();
    _loadBookmarkedPostIds();
  }

  Future<void> _loadBookmarkedPostIds() async {
    final bookmarks = await ref
        .read(bookmarkedItemsPrefsProvider)
        .getBookmarkedPosts();
    if (!mounted) return;
    setState(() {
      _bookmarkedPostIds = {for (final bookmark in bookmarks) bookmark.postId};
    });
  }

  void _previousPost() {
    if (_selectedIndex <= 0) return;
    setState(() {
      _selectedIndex -= 1;
      _overlayVisible = false;
    });
  }

  Future<void> _nextPost() async {
    final state = _currentPostsState();
    if (state == null || state.posts.isEmpty) return;

    final nextIndex = _selectedIndex + 1;
    if (nextIndex < state.posts.length) {
      setState(() {
        _selectedIndex = nextIndex;
        _overlayVisible = false;
      });
      return;
    }

    if (!state.hasMore || state.isLoadingMore) return;

    try {
      await ref.read(feedNotifierProvider.notifier).loadMore();
      final updatedState = _currentPostsState();
      if (!mounted || updatedState == null) return;
      if (nextIndex < updatedState.posts.length) {
        setState(() {
          _selectedIndex = nextIndex;
          _overlayVisible = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not load more.')));
    }
  }

  _EinkPostsState? _currentPostsState() {
    return switch (widget.source) {
      EinkFeedSource.feed =>
        ref.read(feedNotifierProvider).valueOrNull?._toEinkPostsState(),
      EinkFeedSource.bookmarks =>
        ref.read(bookmarksNotifierProvider).valueOrNull?._toEinkPostsState(),
    };
  }

  Post? _currentSelectedPost() {
    final state = _currentPostsState();
    if (state == null || state.posts.isEmpty) return null;

    final selectedIndex = _selectedIndex.clamp(0, state.posts.length - 1);
    return state.posts[selectedIndex];
  }

  Future<void> _refresh() {
    _loadBookmarkedPostIds();
    return switch (widget.source) {
      EinkFeedSource.feed => ref.read(feedNotifierProvider.notifier).refresh(),
      EinkFeedSource.bookmarks =>
        ref.read(bookmarksNotifierProvider.notifier).refresh(),
    };
  }

  void _toggleOverlay() {
    setState(() => _overlayVisible = !_overlayVisible);
  }

  void _hideOverlay() {
    if (!_overlayVisible) return;
    setState(() => _overlayVisible = false);
  }

  void _savePost(Post post) {
    setState(() => _overlayVisible = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Save action coming soon.')));
  }

  void _replyToPost(Post post) {
    setState(() => _overlayVisible = false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostDetailPage(post: post, initiallyReplying: true),
      ),
    );
  }

  Future<void> _showLongPressSheet() async {
    final post = _currentSelectedPost();
    if (post == null) return;

    if (_overlayVisible) {
      setState(() => _overlayVisible = false);
    }

    final theme = context.theme;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.background,
      barrierColor: theme.foreground.withValues(alpha: 0.18),
      isScrollControlled: true,
      builder: (context) => _PostRepliesSheet(post: post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final postsAsync = switch (widget.source) {
      EinkFeedSource.feed =>
        ref
            .watch(feedNotifierProvider)
            .whenData((state) => state._toEinkPostsState()),
      EinkFeedSource.bookmarks =>
        ref
            .watch(bookmarksNotifierProvider)
            .whenData((state) => state._toEinkPostsState()),
    };

    return ColoredBox(
      color: theme.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPress: _showLongPressSheet,
            onTapUp: (details) {
              final width = constraints.maxWidth;
              final x = details.localPosition.dx;

              if (x < width * _previousTapZoneEnd) {
                _previousPost();
                return;
              }

              if (x < width * _overlayTapZoneEnd) {
                _toggleOverlay();
                return;
              }

              _nextPost();
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    _EinkPageTitle(_title),
                    Expanded(
                      child: postsAsync.when(
                        loading: () => const _CenteredStatus('Loading...'),
                        error: (error, _) => _EinkFeedErrorView(
                          message: _errorMessage(error),
                          onRetry: _refresh,
                        ),
                        data: (state) {
                          if (state.posts.isEmpty) {
                            return _CenteredStatus(switch (widget.source) {
                              EinkFeedSource.feed => 'No posts yet.',
                              EinkFeedSource.bookmarks =>
                                'No bookmarked posts yet.',
                            });
                          }

                          final selectedIndex = _selectedIndex.clamp(
                            0,
                            state.posts.length - 1,
                          );
                          final selectedPost = state.posts[selectedIndex];
                          final bookmarked = _bookmarkedPostIds.contains(
                            selectedPost.postId,
                          );

                          return Stack(
                            children: [
                              Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 720,
                                  ),
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        EinkPostCard(
                                          post: selectedPost,
                                          full: true,
                                        ),
                                        if (state.isLoadingMore) ...[
                                          const SizedBox(height: 16),
                                          const _CenteredStatus(
                                            'Loading more...',
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: IgnorePointer(
                                  ignoring: !_overlayVisible,
                                  child: AnimatedOpacity(
                                    opacity: _overlayVisible ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: _ActionsOverlay(
                                      bookmarked: bookmarked,
                                      onSave: () => _savePost(selectedPost),
                                      onReply: () => _replyToPost(selectedPost),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                if (widget.destinationSheetBuilder case final builder?)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      ignoring: !_overlayVisible,
                      child: AnimatedOpacity(
                        opacity: _overlayVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: builder(context, _hideOverlay),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PostRepliesSheet extends ConsumerStatefulWidget {
  final Post post;

  const _PostRepliesSheet({required this.post});

  @override
  ConsumerState<_PostRepliesSheet> createState() => _PostRepliesSheetState();
}

class _PostRepliesSheetState extends ConsumerState<_PostRepliesSheet> {
  static const _loadMoreThreshold = 320.0;

  final _scrollController = ScrollController();

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
      ref.read(postDetailNotifierProvider(widget.post).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final detailAsync = ref.watch(postDetailNotifierProvider(widget.post));

    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.72,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.background,
            border: Border(top: BorderSide(color: theme.border, width: 1)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Replies',
                  style: theme.mainFont.copyWith(
                    color: theme.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: detailAsync.when(
                    loading: () => const _CenteredStatus('Loading replies...'),
                    error: (error, _) => _RepliesErrorView(
                      message: _errorMessage(error),
                      onRetry: () => ref
                          .read(
                            postDetailNotifierProvider(widget.post).notifier,
                          )
                          .refresh(),
                    ),
                    data: (state) {
                      if (state.replies.isEmpty) {
                        return const _CenteredStatus('No replies yet.');
                      }

                      return ListView.separated(
                        controller: _scrollController,
                        itemCount:
                            state.replies.length +
                            (state.isLoadingMore || state.hasMore ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index < state.replies.length) {
                            return ReplyCard(reply: state.replies[index]);
                          }

                          if (state.isLoadingMore) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: _CenteredStatus('Loading more...'),
                            );
                          }

                          return const SizedBox(height: 1);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RepliesErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _RepliesErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center, style: theme.mainFont),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EinkPageTitle extends StatelessWidget {
  final String title;

  const _EinkPageTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.mainFont.copyWith(
          color: theme.foreground,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EinkPostsState {
  final List<Post> posts;
  final bool hasMore;
  final bool isLoadingMore;

  const _EinkPostsState({
    required this.posts,
    required this.hasMore,
    required this.isLoadingMore,
  });
}

extension on FeedState {
  _EinkPostsState _toEinkPostsState() {
    return _EinkPostsState(
      posts: posts,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
    );
  }
}

extension on BookmarksState {
  _EinkPostsState _toEinkPostsState() {
    return _EinkPostsState(posts: posts, hasMore: false, isLoadingMore: false);
  }
}

class _ActionsOverlay extends StatelessWidget {
  final bool bookmarked;
  final VoidCallback onSave;
  final VoidCallback onReply;

  const _ActionsOverlay({
    required this.bookmarked,
    required this.onSave,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background.withValues(alpha: 0.88),
        border: Border.all(color: theme.border, width: 1),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OverlayAction(
              icon: bookmarked
                  ? LucideIcons.bookmarkMinus
                  : LucideIcons.bookmark,
              label: bookmarked ? 'Remove bookmark' : 'Save',
              onTap: onSave,
            ),
            const SizedBox(width: 20),
            _OverlayAction(
              icon: LucideIcons.messageSquare,
              label: 'Reply',
              onTap: onReply,
            ),
          ],
        ),
      ),
    );
  }
}

class _OverlayAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OverlayAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Tooltip(
      message: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 72,
          height: 72,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.background,
              border: Border.all(color: theme.foreground, width: 1),
            ),
            child: Icon(icon, color: theme.foreground, size: 32),
          ),
        ),
      ),
    );
  }
}

String _errorMessage(Object error) {
  debugPrint('E Ink feed load error: $error (${error.runtimeType})');
  if (error is CyberspaceApiException) return error.message;
  return 'Something went wrong.';
}

class _CenteredStatus extends StatelessWidget {
  final String message;

  const _CenteredStatus(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: context.theme.mainFont));
  }
}

class _EinkFeedErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _EinkFeedErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('[ERROR]', style: theme.mainFont),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: theme.mainFont),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
