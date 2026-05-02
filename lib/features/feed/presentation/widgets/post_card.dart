import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/images/images.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final theme = context.theme;
    final post = widget.post;
    final showDelete =
        widget.onDelete != null &&
        _currentUserId != null &&
        post.authorId == _currentUserId &&
        !post.deleted;

    final card = Container(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: theme.border, width: 1),
      ),
      padding: _cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(post: post),
          const SizedBox(height: _sectionGap),
          const _PostSectionDivider(),
          const SizedBox(height: _sectionGap),
          if (post.deleted)
            Text(
              '[post deleted]',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: theme.dimmed,
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
    final theme = context.theme;
    final contentStyle = theme.mainFont;
    final audioAttachment = _AudioAttachment.fromPost(post);

    final content = _decodePostContent(post.content);
    final truncated = _canExpand(post) && !_expanded;
    final displayText = truncated
        ? '${content.substring(0, _truncateAt)}…'
        : content;
    final segments = _PostContentSegment.parse(displayText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, segment) in segments.indexed) ...[
          if (index > 0) const SizedBox(height: 8),
          switch (segment) {
            _TextSegment(:final text) => _PostText(
              text: text,
              style: contentStyle,
              selectable: widget.onTap == null,
            ),
            _ImageSegment(:final altText, :final url) => _PostImage(
              altText: altText,
              url: url,
            ),
          },
        ],
        if (audioAttachment != null) ...[
          if (segments.isNotEmpty) const SizedBox(height: 10),
          _AudioAttachmentBox(attachment: audioAttachment),
        ],
      ],
    );
  }

  bool _canExpand(Post post) =>
      !_full && _decodePostContent(post.content).length > _truncateAt;

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

String _decodePostContent(String content) {
  return content
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', '\n');
}

class _PostSectionDivider extends StatelessWidget {
  const _PostSectionDivider();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SizedBox(
      height: 1,
      child: DecoratedBox(decoration: BoxDecoration(color: theme.border)),
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
  final theme = context.theme;
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme.background,
          surfaceTintColor: theme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: theme.border),
          ),
          title: Text(
            'Delete post?',
            style: theme.mainFont.copyWith(
              color: theme.foreground,
              fontSize: 18,
            ),
          ),
          content: Text(
            'This post and its replies will be removed.',
            style: theme.mainFont.copyWith(color: theme.dimmed),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: theme.dimmed,
                textStyle: theme.mainFont,
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: theme.foreground,
                foregroundColor: theme.background,
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
    final theme = context.theme;

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
                      color: theme.dimmed,
                    ),
                  )
                : Icon(icon, size: 24, color: theme.dimmed),
          ),
        ),
      ),
    );
  }
}

class _InlineLink {
  final String text;
  final Uri uri;

  const _InlineLink({required this.text, required this.uri});
}

sealed class _InlineTextSegment {
  const _InlineTextSegment();

  static final _linkPattern = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');

  static List<_InlineTextSegment> parse(String text) {
    final segments = <_InlineTextSegment>[];
    var cursor = 0;

    for (final match in _linkPattern.allMatches(text)) {
      if (match.start > cursor) {
        segments.add(_PlainInlineText(text.substring(cursor, match.start)));
      }

      final linkedText = match.group(1)?.trim() ?? '';
      final uri = _parseLinkUri(match.group(2));
      if (linkedText.isEmpty || uri == null) {
        segments.add(_PlainInlineText(match.group(0) ?? ''));
      } else {
        segments.add(
          _LinkedInlineText(_InlineLink(text: linkedText, uri: uri)),
        );
      }

      cursor = match.end;
    }

    if (cursor < text.length) {
      segments.add(_PlainInlineText(text.substring(cursor)));
    }

    return segments;
  }

  static Uri? _parseLinkUri(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;

    final uri = Uri.tryParse(text);
    if (uri == null) return null;
    if (uri.hasScheme) return uri;

    return Uri.tryParse('https://$text');
  }
}

class _PlainInlineText extends _InlineTextSegment {
  final String text;

  const _PlainInlineText(this.text);
}

class _LinkedInlineText extends _InlineTextSegment {
  final _InlineLink link;

  const _LinkedInlineText(this.link);
}

class _PostText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool selectable;

  const _PostText({
    required this.text,
    required this.style,
    required this.selectable,
  });

  @override
  State<_PostText> createState() => _PostTextState();
}

class _PostTextState extends State<_PostText> {
  late List<_InlineTextSegment> _segments;
  final _linkRecognizers = <_InlineLink, TapGestureRecognizer>{};

  @override
  void initState() {
    super.initState();
    _syncSegments();
  }

  @override
  void didUpdateWidget(covariant _PostText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) _syncSegments();
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final linkStyle = widget.style.copyWith(
      color: theme.foreground,
      decoration: TextDecoration.underline,
      decorationColor: theme.foreground,
    );

    final spans = [
      for (final segment in _segments)
        switch (segment) {
          _PlainInlineText(:final text) => TextSpan(text: text),
          _LinkedInlineText(:final link) => TextSpan(
            text: link.text,
            style: linkStyle,
            recognizer: _linkRecognizers[link],
          ),
        },
    ];

    final textSpan = TextSpan(style: widget.style, children: spans);

    if (widget.selectable) return SelectableText.rich(textSpan);

    return Text.rich(textSpan);
  }

  void _syncSegments() {
    _disposeRecognizers();
    _segments = _InlineTextSegment.parse(widget.text);
    for (final segment in _segments) {
      if (segment is! _LinkedInlineText) continue;
      _linkRecognizers[segment.link] = TapGestureRecognizer()
        ..onTap = () => launchUrl(segment.link.uri);
    }
  }

  void _disposeRecognizers() {
    for (final recognizer in _linkRecognizers.values) {
      recognizer.dispose();
    }
    _linkRecognizers.clear();
  }
}

class _AudioAttachment {
  final String title;
  final String artist;
  final Uri src;

  const _AudioAttachment({
    required this.title,
    required this.artist,
    required this.src,
  });

  static _AudioAttachment? fromPost(Post post) {
    if (!post.hasAudioAttachment) return null;

    for (final attachment in post.attachments) {
      if (attachment is! Map) continue;
      if (attachment['type'] != 'audio') continue;

      final src = Uri.tryParse('${attachment['src'] ?? ''}');
      if (src == null || !src.hasScheme) continue;

      return _AudioAttachment(
        title: _stringValue(attachment['title'], fallback: '[untitled audio]'),
        artist: _stringValue(
          attachment['artist'],
          fallback: '[unknown artist]',
        ),
        src: src,
      );
    }

    return null;
  }

  static String _stringValue(Object? value, {required String fallback}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }
}

class _AudioAttachmentBox extends StatelessWidget {
  final _AudioAttachment attachment;

  const _AudioAttachmentBox({required this.attachment});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Semantics(
      button: true,
      label: 'Open audio ${attachment.title} by ${attachment.artist}',
      child: InkWell(
        onTap: () => launchUrl(attachment.src),
        hoverColor: theme.foreground.withValues(alpha: 0.08),
        focusColor: theme.foreground.withValues(alpha: 0.08),
        splashColor: theme.foreground.withValues(alpha: 0.12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.border, width: 1),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(LucideIcons.music, size: 18, color: theme.foreground),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.title,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: theme.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      attachment.artist,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: theme.dimmed,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(LucideIcons.externalLink, size: 16, color: theme.dimmed),
            ],
          ),
        ),
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  final Reply reply;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ReplyCard({
    super.key,
    required this.reply,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: theme.border, width: 1),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ReplyHeader(
            reply: reply,
            onDelete: reply.deleted || isDeleting ? null : onDelete,
            isDeleting: isDeleting,
          ),
          const SizedBox(height: 10),
          if (reply.deleted)
            Text(
              '[reply deleted]',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: theme.dimmed,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            _PostText(
              text: _decodePostContent(reply.content),
              selectable: true,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: theme.foreground,
                height: 1.4,
              ),
            ),
        ],
      ),
    );
  }
}

sealed class _PostContentSegment {
  const _PostContentSegment();

  // ignore: deprecated_member_use
  static final _imagePattern = RegExp(r'!\[([^\]]*)\]\((https?:\/\/[^)\s]+)\)');

  static List<_PostContentSegment> parse(String content) {
    final segments = <_PostContentSegment>[];
    var cursor = 0;

    for (final match in _imagePattern.allMatches(content)) {
      if (match.start > cursor) {
        final text = content.substring(cursor, match.start);
        if (text.isNotEmpty) segments.add(_TextSegment(text));
      }

      segments.add(_ImageSegment(match.group(1) ?? '', match.group(2)!));
      cursor = match.end;
    }

    if (cursor < content.length) {
      final text = content.substring(cursor);
      if (text.isNotEmpty) segments.add(_TextSegment(text));
    }

    return segments;
  }
}

class _TextSegment extends _PostContentSegment {
  final String text;

  const _TextSegment(this.text);
}

class _ImageSegment extends _PostContentSegment {
  final String altText;
  final String url;

  const _ImageSegment(this.altText, this.url);
}

class _PostImage extends StatelessWidget {
  final String altText;
  final String url;

  const _PostImage({required this.altText, required this.url});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Semantics(
      label: altText.isEmpty ? 'Post image' : altText,
      image: true,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 420),
        decoration: BoxDecoration(
          border: Border.all(color: theme.border, width: 1),
        ),
        clipBehavior: Clip.hardEdge,
        child: DitheredNetworkImage(
          url: url,
          fit: BoxFit.contain,
          settings: theme.isDark
              ? DitherShaderSettings(
                  foreground: theme.foreground,
                  background: theme.background,
                )
              : DitherShaderSettings(
                  foreground: theme.background,
                  background: theme.foreground,
                ),
          placeholderBuilder: (_) => const _PostImagePlaceholder(),
          errorBuilder: (_) => const _PostImageError(),
        ),
      ),
    );
  }
}

class _PostImagePlaceholder extends StatelessWidget {
  const _PostImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SizedBox(
      height: 180,
      child: Center(
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: theme.dimmed,
          ),
        ),
      ),
    );
  }
}

class _PostImageError extends StatelessWidget {
  const _PostImageError();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SizedBox(
      height: 120,
      child: Center(
        child: Text(
          '[image failed to load]',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: theme.dimmed,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Post post;
  const _Header({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      children: [
        Expanded(
          child: Text(
            '@${post.authorUsername}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: theme.foreground,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${_relativeTime(post.createdAt)} · ${post.content.length} · ${post.repliesCount}',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: theme.dimmed,
          ),
        ),
      ],
    );
  }
}

class _ReplyHeader extends StatelessWidget {
  final Reply reply;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const _ReplyHeader({
    required this.reply,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      children: [
        Expanded(
          child: Text(
            '@${reply.authorUsername}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: theme.foreground,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _relativeTime(reply.createdAt),
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: theme.dimmed,
          ),
        ),
        if (onDelete != null || isDeleting) ...[
          const SizedBox(width: 4),
          IconButton(
            onPressed: isDeleting ? null : onDelete,
            tooltip: 'Delete reply',
            icon: isDeleting
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: theme.dimmed,
                    ),
                  )
                : const Icon(LucideIcons.trash2),
            color: theme.dimmed,
            hoverColor: theme.foreground.withValues(alpha: 0.08),
            focusColor: theme.foreground.withValues(alpha: 0.08),
            splashColor: theme.foreground.withValues(alpha: 0.12),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String topic;
  const _TopicChip({required this.topic});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dimmed, width: 1),
      ),
      child: Text(
        '#$topic',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          color: theme.dimmed,
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
