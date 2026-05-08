import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart' hide RichText;
import 'package:onosendai/features/theme/theme.dart';
import 'package:onosendai/core/widgets/rich_text.dart';

class EinkPostCard extends StatefulWidget {
  final Post post;
  final bool full;

  const EinkPostCard({super.key, required this.post, this.full = false});

  @override
  State<EinkPostCard> createState() => _EinkPostCardState();
}

class _EinkPostCardState extends State<EinkPostCard> {
  static const _truncateAt = 512;
  static const _cardPadding = EdgeInsets.fromLTRB(14, 12, 14, 12);
  static const _sectionGap = 10.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final post = widget.post;

    return Container(
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
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Post post) {
    final theme = context.theme;
    final contentStyle = theme.mainFont;

    final content = RichText.decodeContent(post.content);
    final truncated = _canExpand(post);
    final displayText = truncated
        ? '${content.substring(0, _truncateAt)}...'
        : content;

    return IgnorePointer(
      child: RichText(
        content: displayText,
        style: contentStyle,
        selectable: false,
        attachments: post.attachments,
        decodeHtml: false,
      ),
    );
  }

  bool _canExpand(Post post) =>
      !widget.full && RichText.decodeContent(post.content).length > _truncateAt;
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

class _Header extends StatelessWidget {
  final Post post;
  const _Header({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
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
        const SizedBox(height: 3),
        Text(
          '${_relativeTime(post.createdAt)} ago · ${post.content.length} chars · ${post.repliesCount} replies',
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
