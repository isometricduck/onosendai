import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart' hide RichText;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/features/profiles/presentation/pages/user_profile_page.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/core/widgets/rich_text.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onReply;
  final Future<void> Function(Post post)? onDelete;
  final bool full;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onReply,
    this.onDelete,
    this.full = false,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _expanded = false;
  bool _full = false;
  bool _savingBookmark = false;
  bool _deletingPost = false;
  String? _bookmarkId;
  String? _currentUserId;

  static const _truncateAt = 512;
  static const _cardPadding = EdgeInsets.fromLTRB(14, 12, 14, 12);
  static const _sectionGap = 10.0;

  @override
  void initState() {
    super.initState();
    _full = widget.full;
    _loadBookmarkState();
    _loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final post = widget.post;
    final showDelete =
        widget.onDelete != null &&
        _currentUserId != null &&
        post.authorId == _currentUserId &&
        !post.deleted;

    final card = Container(
      decoration: BoxDecoration(
        color: theme.cardBackground,
        border: Border.all(color: theme.cardBorder, width: 1),
      ),
      padding: _cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            post: post,
            onAuthorTap: () => _openProfile(context, post.authorUsername),
          ),
          const SizedBox(height: _sectionGap),
          const _PostSectionDivider(),
          const SizedBox(height: _sectionGap),
          if (post.deleted)
            Text(
              '[post deleted]',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: theme.hintText,
                fontStyle: FontStyle.italic,
              ),
            )
          else ...[
            if (post.isNSFW) ...[
              Text(
                '[NSFW]',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: const Color(0xFFcc241d),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
            ],
            _buildContent(context, post),
          ],
          if (post.topics.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final topic in post.topics) _TopicChip(topic: topic),
              ],
            ),
          ],
          const SizedBox(height: _sectionGap),
          const _PostSectionDivider(),
          const SizedBox(height: _sectionGap),
          _PostActionBar(
            visible: _canExpand(post),
            expanded: _expanded,
            onReplyTap: widget.onReply,
            onExpandTap: () => setState(() => _expanded = !_expanded),
            onSaveTap: _saveBookmark,
            onRemoveSaveTap: _removeBookmark,
            savingBookmark: _savingBookmark,
            bookmarked: _bookmarkId != null,
            showDelete: showDelete,
            deletingPost: _deletingPost,
            onDeleteTap: _deletePost,
          ),
        ],
      ),
    );

    if (widget.onTap == null) return card;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: widget.onTap,
        child: card,
      ),
    );
  }

  Widget _buildContent(BuildContext context, Post post) {
    final theme = context.cyberTheme;
    final contentStyle = theme.mainFont;

    final content = RichText.decodeContent(post.content);
    final truncated = _canExpand(post) && !_expanded;
    final displayText = truncated
        ? '${content.substring(0, _truncateAt)}…'
        : content;

    return RichText(
      content: displayText,
      style: contentStyle,
      selectable: widget.onTap == null,
      attachments: post.attachments,
      decodeHtml: false,
    );
  }

  bool _canExpand(Post post) =>
      !_full && RichText.decodeContent(post.content).length > _truncateAt;

  Future<void> _loadBookmarkState() async {
    final bookmarks = await ref
        .read(bookmarkedItemsPrefsProvider)
        .getBookmarkedPosts();
    if (!mounted) return;

    String? bookmarkId;
    for (final bookmark in bookmarks) {
      if (bookmark.postId == widget.post.postId) {
        bookmarkId = bookmark.bookmarkId;
        break;
      }
    }

    setState(() {
      _bookmarkId = bookmarkId;
    });
  }

  Future<void> _loadCurrentUser() async {
    final profile = await ref.read(currentUserPrefsProvider).getProfile();
    if (!mounted) return;

    setState(() {
      _currentUserId = profile?.userId;
    });
  }

  Future<void> _saveBookmark() async {
    if (_savingBookmark || _bookmarkId != null) return;

    setState(() => _savingBookmark = true);
    try {
      final bookmarkId = await ref
          .read(cyberspaceClientProvider)
          .bookmarks
          .bookmarkPost(widget.post.postId);
      await ref
          .read(bookmarkedItemsPrefsProvider)
          .addPostBookmark(bookmarkId: bookmarkId, postId: widget.post.postId);
      if (!mounted) return;
      setState(() {
        _savingBookmark = false;
        _bookmarkId = bookmarkId;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _savingBookmark = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not save bookmark.')));
    }
  }

  Future<void> _removeBookmark() async {
    final bookmarkId = _bookmarkId;
    if (_savingBookmark || bookmarkId == null) return;

    setState(() => _savingBookmark = true);
    try {
      await ref.read(cyberspaceClientProvider).bookmarks.remove(bookmarkId);
      await ref
          .read(bookmarkedItemsPrefsProvider)
          .removePostBookmark(widget.post.postId);
      if (!mounted) return;
      setState(() {
        _savingBookmark = false;
        _bookmarkId = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _savingBookmark = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not remove bookmark.')),
      );
    }
  }

  Future<void> _deletePost() async {
    if (_deletingPost || widget.onDelete == null) return;

    final confirmed = await _confirmDeletePost(context);
    if (!confirmed || !mounted) return;

    setState(() => _deletingPost = true);
    try {
      await widget.onDelete!(widget.post);
      if (!mounted) return;
      setState(() => _deletingPost = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _deletingPost = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not delete post.')));
    }
  }
}

class _PostSectionDivider extends StatelessWidget {
  const _PostSectionDivider();

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return SizedBox(
      height: 1,
      child: DecoratedBox(decoration: BoxDecoration(color: theme.divider)),
    );
  }
}

class _PostActionBar extends StatelessWidget {
  final bool visible;
  final bool expanded;
  final VoidCallback? onReplyTap;
  final VoidCallback onExpandTap;
  final VoidCallback onSaveTap;
  final VoidCallback onRemoveSaveTap;
  final bool savingBookmark;
  final bool bookmarked;
  final bool showDelete;
  final bool deletingPost;
  final VoidCallback onDeleteTap;

  const _PostActionBar({
    required this.visible,
    required this.expanded,
    required this.onReplyTap,
    required this.onExpandTap,
    required this.onSaveTap,
    required this.onRemoveSaveTap,
    required this.savingBookmark,
    required this.bookmarked,
    required this.showDelete,
    required this.deletingPost,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PostActionIcon(
          icon: bookmarked ? LucideIcons.bookmarkMinus : LucideIcons.bookmark,
          tooltip: bookmarked ? 'Remove bookmark' : 'Save',
          onTap: bookmarked ? onRemoveSaveTap : onSaveTap,
          busy: savingBookmark,
        ),
        const SizedBox(width: 18),
        _PostActionIcon(
          icon: LucideIcons.messageSquare,
          tooltip: 'Reply',
          onTap: onReplyTap,
        ),
        const SizedBox(width: 18),
        Visibility(
          visible: visible,
          maintainAnimation: true,
          maintainSize: true,
          maintainState: true,
          child: _PostActionIcon(
            icon: expanded
                ? LucideIcons.foldVertical
                : LucideIcons.unfoldVertical,
            tooltip: expanded ? 'Collapse' : 'Expand',
            onTap: onExpandTap,
          ),
        ),
        const Spacer(),
        if (showDelete)
          _PostActionIcon(
            icon: LucideIcons.trash2,
            tooltip: 'Delete post',
            onTap: onDeleteTap,
            busy: deletingPost,
          ),
      ],
    );
  }
}

Future<bool> _confirmDeletePost(BuildContext context) async {
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
            'Delete post?',
            style: theme.mainFont.copyWith(
              color: theme.headingText,
              fontSize: 18,
            ),
          ),
          content: Text(
            'This post and its replies will be removed.',
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

class _PostActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool busy;

  const _PostActionIcon({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap ?? () {},
        child: SizedBox.square(
          dimension: 28,
          child: Center(
            child: busy
                ? SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.actionIcon,
                    ),
                  )
                : Icon(icon, size: 24, color: theme.actionIcon),
          ),
        ),
      ),
    );
  }
}

class ReplyCard extends ConsumerStatefulWidget {
  final Reply reply;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ReplyCard({
    super.key,
    required this.reply,
    this.onReply,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  ConsumerState<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends ConsumerState<ReplyCard> {
  bool _savingBookmark = false;
  String? _bookmarkId;

  @override
  void initState() {
    super.initState();
    _loadBookmarkState();
  }

  @override
  void didUpdateWidget(covariant ReplyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reply.replyId != widget.reply.replyId) {
      _bookmarkId = null;
      _loadBookmarkState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final reply = widget.reply;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardBackground,
        border: Border.all(color: theme.cardBorder, width: 1),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ReplyHeader(reply: reply),
          const SizedBox(height: 10),
          if (reply.deleted)
            Text('[reply deleted]', style: theme.mainFont)
          else
            RichText(content: reply.content, style: theme.mainFont),
          const SizedBox(height: 10),
          _PostSectionDivider(),
          const SizedBox(height: 10),
          _ReplyActionBar(
            onReplyTap: reply.deleted ? null : widget.onReply,
            onSaveTap: _saveBookmark,
            onRemoveSaveTap: _removeBookmark,
            savingBookmark: _savingBookmark,
            bookmarked: _bookmarkId != null,
            showDelete: widget.onDelete != null && !reply.deleted,
            isDeleting: widget.isDeleting,
            onDeleteTap: widget.onDelete,
          ),
        ],
      ),
    );
  }

  Future<void> _loadBookmarkState() async {
    final bookmarks = await ref
        .read(bookmarkedItemsPrefsProvider)
        .getBookmarkedReplies();
    if (!mounted) return;

    String? bookmarkId;
    for (final bookmark in bookmarks) {
      if (bookmark.replyId == widget.reply.replyId) {
        bookmarkId = bookmark.bookmarkId;
        break;
      }
    }

    setState(() {
      _bookmarkId = bookmarkId;
    });
  }

  Future<void> _saveBookmark() async {
    if (_savingBookmark || _bookmarkId != null || widget.reply.deleted) return;

    setState(() => _savingBookmark = true);
    try {
      final bookmarkId = await ref
          .read(cyberspaceClientProvider)
          .bookmarks
          .bookmarkReply(widget.reply.replyId);
      await ref
          .read(bookmarkedItemsPrefsProvider)
          .addReplyBookmark(
            bookmarkId: bookmarkId,
            replyId: widget.reply.replyId,
          );
      if (!mounted) return;
      setState(() {
        _savingBookmark = false;
        _bookmarkId = bookmarkId;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _savingBookmark = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not save bookmark.')));
    }
  }

  Future<void> _removeBookmark() async {
    final bookmarkId = _bookmarkId;
    if (_savingBookmark || bookmarkId == null) return;

    setState(() => _savingBookmark = true);
    try {
      await ref.read(cyberspaceClientProvider).bookmarks.remove(bookmarkId);
      await ref
          .read(bookmarkedItemsPrefsProvider)
          .removeReplyBookmark(widget.reply.replyId);
      if (!mounted) return;
      setState(() {
        _savingBookmark = false;
        _bookmarkId = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _savingBookmark = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not remove bookmark.')),
      );
    }
  }
}

class _ReplyActionBar extends StatelessWidget {
  final VoidCallback? onReplyTap;
  final VoidCallback onSaveTap;
  final VoidCallback onRemoveSaveTap;
  final bool savingBookmark;
  final bool bookmarked;
  final bool showDelete;
  final bool isDeleting;
  final VoidCallback? onDeleteTap;

  const _ReplyActionBar({
    required this.onReplyTap,
    required this.onSaveTap,
    required this.onRemoveSaveTap,
    required this.savingBookmark,
    required this.bookmarked,
    required this.showDelete,
    required this.isDeleting,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PostActionIcon(
          icon: bookmarked ? LucideIcons.bookmarkMinus : LucideIcons.bookmark,
          tooltip: bookmarked ? 'Remove bookmark' : 'Save',
          onTap: bookmarked ? onRemoveSaveTap : onSaveTap,
          busy: savingBookmark,
        ),
        const SizedBox(width: 18),
        _PostActionIcon(
          icon: LucideIcons.messageSquare,
          tooltip: 'Reply',
          onTap: onReplyTap,
        ),
        const Spacer(),
        if (showDelete || isDeleting)
          _PostActionIcon(
            icon: LucideIcons.trash2,
            tooltip: 'Delete reply',
            onTap: isDeleting ? null : onDeleteTap,
            busy: isDeleting,
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final Post post;
  final VoidCallback onAuthorTap;

  const _Header({required this.post, required this.onAuthorTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onAuthorTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(
              '@${post.authorUsername}',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: theme.headingText,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${_relativeTime(post.createdAt)} ago · ${post.content.length} chars · ${post.repliesCount} replies',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: theme.metaText,
          ),
        ),
      ],
    );
  }
}

class _ReplyHeader extends StatelessWidget {
  final Reply reply;

  const _ReplyHeader({required this.reply});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _openProfile(context, reply.authorUsername),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                '@${reply.authorUsername}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: theme.headingText,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _relativeTime(reply.createdAt),
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: theme.metaText,
          ),
        ),
      ],
    );
  }
}

void _openProfile(BuildContext context, String username) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => UserProfilePage(username: username)),
  );
}

class _TopicChip extends StatelessWidget {
  final String topic;
  const _TopicChip({required this.topic});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: theme.metaText, width: 1),
      ),
      child: Text(
        '#$topic',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          color: theme.metaText,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

String _relativeTime(DateTime createdAt) {
  final now = DateTime.now();
  final diff = now.difference(createdAt);
  if (diff.inSeconds < 30) return 'just now';
  if (diff.inMinutes < 1) return '${diff.inSeconds}s';
  if (diff.inHours < 1) return '${diff.inMinutes}m';
  if (diff.inDays < 1) return '${diff.inHours}h';
  if (diff.inDays < 30) return '${diff.inDays}d';
  return '${createdAt.year.toString().padLeft(4, '0')}-'
      '${createdAt.month.toString().padLeft(2, '0')}-'
      '${createdAt.day.toString().padLeft(2, '0')}';
}
