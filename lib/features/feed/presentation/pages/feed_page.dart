import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/feed/domain/entities/feed_state.dart';
import 'package:onosendai/features/feed/presentation/pages/post_detail_page.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
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
    final theme = context.theme;
    final feedAsync = ref.watch(feedNotifierProvider);

    return ColoredBox(
      color: theme.background,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: feedAsync.when(
              loading: () => const _CenteredSpinner(),
              error: (err, _) => _ErrorView(
                message: _errorMessage(err),
                onRetry: () =>
                    ref.read(feedNotifierProvider.notifier).refresh(),
              ),
              data: (state) => _FeedList(
                state: state,
                scrollController: _scrollController,
                onRefresh: () =>
                    ref.read(feedNotifierProvider.notifier).refresh(),
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

class _FeedList extends StatelessWidget {
  final FeedState state;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  const _FeedList({
    required this.state,
    required this.scrollController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
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
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
              ),
              onReply: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      PostDetailPage(post: post, initiallyReplying: true),
                ),
              ),
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
          color: context.theme.dimmed,
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
            color: context.theme.dimmed,
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('[ERROR]', style: theme.mainFont),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: theme.mainFont),
            const SizedBox(height: 20),
            _RetryButton(onTap: onRetry),
          ],
        ),
      ),
    );
  }
}

class _RetryButton extends StatefulWidget {
  final VoidCallback onTap;
  const _RetryButton({required this.onTap});

  @override
  State<_RetryButton> createState() => _RetryButtonState();
}

class _RetryButtonState extends State<_RetryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered ? theme.foreground : theme.dimmed,
              width: 1,
            ),
          ),
          child: Text('Retry', style: theme.mainFont),
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
    return Text(text, style: context.theme.mainFont);
  }
}
