import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/widgets/error_snackbar.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/feed/domain/entities/feed_state.dart';
import 'package:onosendai/features/feed/presentation/pages/post_detail_page.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/feed/presentation/riverpod/selected_post_provider.dart';
import 'package:onosendai/features/feed/presentation/widgets/post_card.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
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
      ref.read(feedNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final feedAsync = ref.watch(feedNotifierProvider);
    ref.listen(feedNotifierProvider, (_, next) {
      if (!next.hasError || next.isLoading) return;
      showErrorSnackBar(context, _errorMessage(next.error!));
    });

    return ColoredBox(
      color: theme.pageBackground,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: feedAsync.when(
              skipError: true,
              loading: () => const _CenteredSpinner(),
              error: (_, _) => const SizedBox.shrink(),
              data: (state) => _FeedList(
                state: state,
                scrollController: _scrollController,
                onRefresh: () =>
                    ref.read(feedNotifierProvider.notifier).refresh(),
                onDeletePost: (post) => ref
                    .read(feedNotifierProvider.notifier)
                    .deletePost(post.postId),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _errorMessage(Object error) {
  debugPrint('Feed load error: $error (${error.runtimeType})');
  if (error is CyberspaceApiException) return error.message;
  return 'Something went wrong.';
}

class _FeedList extends ConsumerWidget {
  final FeedState state;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final Future<void> Function(Post post) onDeletePost;

  const _FeedList({
    required this.state,
    required this.scrollController,
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

    if (state.posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: _DimmedText('No posts yet.')),
          ],
        ),
      );
    }

    final itemCount = state.posts.length + 1;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index < state.posts.length) {
            final post = state.posts[index];
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
            child: Center(child: _DimmedText('— end of feed —')),
          );
        },
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
