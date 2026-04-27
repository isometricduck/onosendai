import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/feed/domain/entities/post_detail_state.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/feed/presentation/widgets/post_card.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
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
      ref.read(postDetailNotifierProvider(widget.post).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final detailAsync = ref.watch(postDetailNotifierProvider(widget.post));
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    final body = ColoredBox(
      color: theme.background,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: detailAsync.when(
              loading: () => const _CenteredSpinner(),
              error: (err, _) => _ErrorView(
                message: _errorMessage(err),
                onRetry: () => ref
                    .read(postDetailNotifierProvider(widget.post).notifier)
                    .refresh(),
              ),
              data: (state) => _PostDetailList(
                state: state,
                scrollController: _scrollController,
                showInlineHeader: !isMobile,
                onBack: () => Navigator.of(context).maybePop(),
                onRefresh: () => ref
                    .read(postDetailNotifierProvider(widget.post).notifier)
                    .refresh(),
              ),
            ),
          ),
        ),
      ),
    );

    if (!isMobile) {
      return Scaffold(backgroundColor: theme.background, body: body);
    }

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        foregroundColor: theme.foreground,
        surfaceTintColor: theme.background,
        title: Text(
          'ENTRY',
          style: theme.mainFont.copyWith(
            color: theme.foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: body,
    );
  }
}

class _PostDetailList extends StatelessWidget {
  final PostDetailState state;
  final ScrollController scrollController;
  final bool showInlineHeader;
  final VoidCallback onBack;
  final Future<void> Function() onRefresh;

  const _PostDetailList({
    required this.state,
    required this.scrollController,
    required this.showInlineHeader,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final headerOffset = showInlineHeader ? 1 : 0;
    final postIndex = headerOffset;
    final repliesHeaderIndex = postIndex + 1;
    final firstReplyIndex = repliesHeaderIndex + 1;
    final footerIndex = firstReplyIndex + state.replies.length;
    final itemCount = footerIndex + 1;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (showInlineHeader && index == 0) {
            return _InlineHeader(onBack: onBack);
          }

          if (index == postIndex) {
            return PostCard(post: state.post, full: true);
          }

          if (index == repliesHeaderIndex) {
            return _RepliesHeader(count: state.post.repliesCount);
          }

          final replyIndex = index - firstReplyIndex;
          if (replyIndex < state.replies.length) {
            return ReplyCard(reply: state.replies[replyIndex]);
          }

          if (state.isLoadingMore) return const _InlineSpinner();
          if (state.hasMore) return const SizedBox.shrink();

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _InlineHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _InlineHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(LucideIcons.arrowLeft),
          color: theme.foreground,
          tooltip: 'Back',
        ),
        const SizedBox(width: 4),
        Text(
          'Post',
          style: theme.mainFont.copyWith(
            color: theme.foreground,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RepliesHeader extends StatelessWidget {
  final int count;

  const _RepliesHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Text(
      count == 1 ? '1 REPLY' : '$count REPLIES',
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        color: theme.dimmed,
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
          children: [
            Text(
              '[ERROR]',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: const Color(0xFFcc241d),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: theme.foreground,
              ),
            ),
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
          child: Text(
            'Retry',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: theme.foreground,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

String _errorMessage(Object err) {
  if (err is CyberspaceApiException) return err.message;
  return 'Something went wrong.';
}
