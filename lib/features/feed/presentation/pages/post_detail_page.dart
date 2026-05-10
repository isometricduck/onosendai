import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/feed/domain/entities/post_detail_state.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/feed/presentation/widgets/post_card.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final Post post;
  final bool initiallyReplying;

  const PostDetailPage({
    super.key,
    required this.post,
    this.initiallyReplying = false,
  });

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final _scrollController = ScrollController();
  final _replyController = TextEditingController();
  static const _loadMoreThreshold = 400.0;
  var _isReplying = false;
  var _isSubmittingReply = false;
  String? _deletingReplyId;

  @override
  void initState() {
    super.initState();
    _isReplying = widget.initiallyReplying;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _replyController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      ref.read(postDetailNotifierProvider(widget.post).notifier).loadMore();
    }
  }

  Future<void> _submitReply() async {
    final content = _replyController.text.trim();
    if (content.isEmpty || _isSubmittingReply) return;

    setState(() => _isSubmittingReply = true);
    try {
      await ref
          .read(postDetailNotifierProvider(widget.post).notifier)
          .createReply(content);
      _replyController.clear();
      if (!mounted) return;
      setState(() => _isReplying = false);
    } catch (error) {
      if (!mounted) return;
      final theme = context.cyberTheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _errorMessage(error),
            style: theme.mainFont.copyWith(color: theme.snackbarText),
          ),
          backgroundColor: theme.snackbarBackground,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmittingReply = false);
    }
  }

  Future<void> _deleteReply(Reply reply) async {
    if (_deletingReplyId != null) return;

    final confirmed = await _confirmDeleteReply(context);
    if (!confirmed || !mounted) return;

    setState(() => _deletingReplyId = reply.replyId);
    try {
      await ref
          .read(postDetailNotifierProvider(widget.post).notifier)
          .deleteReply(reply.replyId);
    } catch (error) {
      if (!mounted) return;
      final theme = context.cyberTheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _errorMessage(error),
            style: theme.mainFont.copyWith(color: theme.snackbarText),
          ),
          backgroundColor: theme.snackbarBackground,
        ),
      );
    } finally {
      if (mounted) setState(() => _deletingReplyId = null);
    }
  }

  Future<void> _deletePost(Post post) async {
    await ref
        .read(postDetailNotifierProvider(widget.post).notifier)
        .deletePost();
    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final detailAsync = ref.watch(postDetailNotifierProvider(widget.post));
    final currentUser = ref.watch(currentUserProfileProvider).valueOrNull;
    debugPrint("Current user: $currentUser");
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    final body = ColoredBox(
      color: theme.pageBackground,
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
                showReplyComposer: _isReplying,
                replyController: _replyController,
                isSubmittingReply: _isSubmittingReply,
                currentUserId: currentUser?.userId,
                deletingReplyId: _deletingReplyId,
                onReplyChanged: () => setState(() {}),
                onStartReply: () => setState(() => _isReplying = true),
                onSubmitReply: _submitReply,
                onDeletePost: _deletePost,
                onDeleteReply: _deleteReply,
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
      return Scaffold(backgroundColor: theme.pageBackground, body: body);
    }

    return Scaffold(
      backgroundColor: theme.pageBackground,
      appBar: AppBar(
        backgroundColor: theme.pageBackground,
        foregroundColor: theme.headingText,
        surfaceTintColor: theme.pageBackground,
        title: Text(
          'ENTRY',
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

class _PostDetailList extends StatelessWidget {
  final PostDetailState state;
  final ScrollController scrollController;
  final bool showInlineHeader;
  final bool showReplyComposer;
  final TextEditingController replyController;
  final bool isSubmittingReply;
  final String? currentUserId;
  final String? deletingReplyId;
  final VoidCallback onReplyChanged;
  final VoidCallback onStartReply;
  final VoidCallback onSubmitReply;
  final Future<void> Function(Post post) onDeletePost;
  final ValueChanged<Reply> onDeleteReply;
  final VoidCallback onBack;
  final Future<void> Function() onRefresh;

  const _PostDetailList({
    required this.state,
    required this.scrollController,
    required this.showInlineHeader,
    required this.showReplyComposer,
    required this.replyController,
    required this.isSubmittingReply,
    required this.currentUserId,
    required this.deletingReplyId,
    required this.onReplyChanged,
    required this.onStartReply,
    required this.onSubmitReply,
    required this.onDeletePost,
    required this.onDeleteReply,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final headerOffset = showInlineHeader ? 1 : 0;
    final postIndex = headerOffset;
    final repliesHeaderIndex = postIndex + 1;
    final composerOffset = showReplyComposer ? 1 : 0;
    final replyComposerIndex = repliesHeaderIndex + 1;
    final firstReplyIndex = replyComposerIndex + composerOffset;
    final footerIndex = firstReplyIndex + state.replies.length;
    final itemCount = footerIndex + 1;
    final canSubmitReply = replyController.text.trim().isNotEmpty;

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
            return PostCard(
              post: state.post,
              full: true,
              onReply: onStartReply,
              onDelete: onDeletePost,
            );
          }

          if (index == repliesHeaderIndex) {
            return _RepliesHeader(count: state.post.repliesCount);
          }

          if (showReplyComposer && index == replyComposerIndex) {
            return _ReplyComposer(
              controller: replyController,
              canSubmit: canSubmitReply,
              isSubmitting: isSubmittingReply,
              onChanged: onReplyChanged,
              onSubmit: onSubmitReply,
            );
          }

          final replyIndex = index - firstReplyIndex;
          if (replyIndex < state.replies.length) {
            final reply = state.replies[replyIndex];
            debugPrint(
              "Current user id: $currentUserId and author id: ${reply.authorId}",
            );
            final canDelete =
                currentUserId != null && reply.authorId == currentUserId;
            return ReplyCard(
              reply: reply,
              isDeleting: deletingReplyId == reply.replyId,
              onDelete: canDelete ? () => onDeleteReply(reply) : null,
            );
          }

          if (state.isLoadingMore) return const _InlineSpinner();
          if (state.hasMore) return const SizedBox.shrink();

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

Future<bool> _confirmDeleteReply(BuildContext context) async {
  final theme = context.cyberTheme;
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme.dialogBackground,
          surfaceTintColor: theme.dialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: theme.dialogBorder),
          ),
          title: Text(
            'Delete reply?',
            style: theme.mainFont.copyWith(
              color: theme.headingText,
              fontSize: 18,
            ),
          ),
          content: Text(
            'This reply will be removed from the post.',
            style: theme.mainFont.copyWith(color: theme.metaText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: theme.secondaryButtonBorder,
                textStyle: theme.mainFont,
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: theme.primaryButtonBackground,
                foregroundColor: theme.primaryButtonForeground,
                textStyle: theme.mainFont,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ??
      false;
}

class _InlineHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _InlineHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(LucideIcons.arrowLeft),
          color: theme.headingText,
          tooltip: 'Back',
        ),
        const SizedBox(width: 4),
        Text(
          'Post',
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

class _RepliesHeader extends StatelessWidget {
  final int count;

  const _RepliesHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    return Text(
      count == 1 ? '1 REPLY' : '$count REPLIES',
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        color: theme.metaText,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ReplyComposer extends StatelessWidget {
  final TextEditingController controller;
  final bool canSubmit;
  final bool isSubmitting;
  final VoidCallback onChanged;
  final VoidCallback onSubmit;

  const _ReplyComposer({
    required this.controller,
    required this.canSubmit,
    required this.isSubmitting,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          minLines: 4,
          maxLines: 8,
          onChanged: (_) => onChanged(),
          style: theme.mainFont,
          cursorColor: theme.inputFocusBorder,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: theme.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: theme.inputFocusBorder),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: _ReplyTextButton(
            onTap: canSubmit && !isSubmitting ? onSubmit : null,
            isLoading: isSubmitting,
          ),
        ),
      ],
    );
  }
}

class _ReplyTextButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const _ReplyTextButton({required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final enabled = onTap != null;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: enabled ? theme.primaryButtonBackground : theme.secondaryButtonBorder,
        textStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          letterSpacing: 0.5,
        ),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: isLoading
          ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: theme.actionIcon,
              ),
            )
          : Text(
            '[R]EPLY',
            style: context.cyberTheme.mainFont,),
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

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
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
                color: theme.headingText,
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
    final theme = context.cyberTheme;
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
              color: _hovered ? theme.primaryButtonForeground : theme.secondaryButtonBorder,
              width: 1,
            ),
          ),
          child: Text(
            'Retry',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: theme.headingText,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

String _errorMessage(Object err) {
  debugPrint('Post detail load error: $err');
  if (err is CyberspaceApiException) return err.message;
  return 'Something went wrong.';
}
