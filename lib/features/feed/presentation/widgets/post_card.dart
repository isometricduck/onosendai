import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
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
          _Footer(post: post),
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

    final truncated = !_expanded && post.content.length > _truncateAt;
    final displayText =
        truncated ? '${post.content.substring(0, _truncateAt)}…' : post.content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(displayText, style: contentStyle),
        if (truncated || _expanded) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              truncated ? '[+ show more]' : '[- show less]',
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

class _Header extends StatelessWidget {
  final Post post;
  const _Header({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      children: [
        Flexible(
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
          '· ${_relativeTime(post.createdAt)}',
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

class _Footer extends StatelessWidget {
  final Post post;
  const _Footer({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12,
      color: theme.dimmed,
      letterSpacing: 0.4,
    );
    return Row(
      children: [
        Text('R:${post.repliesCount}', style: style),
        const SizedBox(width: 16),
        Text('B:${post.bookmarksCount}', style: style),
      ],
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
