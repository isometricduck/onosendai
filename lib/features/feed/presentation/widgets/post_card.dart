import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:onosendai/core/images/images.dart';
import 'package:onosendai/core/theme/theme.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _expanded = false;

  static const _truncateAt = 512;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final post = widget.post;

    return Container(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: theme.border, width: 1),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(post: post),
          const SizedBox(height: 10),
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
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final topic in post.topics) _TopicChip(topic: topic),
              ],
            ),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Post post) {
    final theme = context.theme;
    final contentStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 14,
      color: theme.foreground,
      height: 1.4,
    );

    final content = post.content.replaceAll('&amp;', '&');
    final truncated = !_expanded && content.length > _truncateAt;
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
            _TextSegment(:final text) => SelectableText(
              text,
              style: contentStyle,
            ),
            _ImageSegment(:final altText, :final url) => _PostImage(
              altText: altText,
              url: url,
            ),
          },
        ],
        if (truncated || _expanded) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              truncated ? '[E]xpand' : '[C]ollapse',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: theme.dimmed,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

sealed class _PostContentSegment {
  const _PostContentSegment();

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
          settings: DitherShaderSettings(
            foreground: theme.foreground,
            background: theme.background,
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
