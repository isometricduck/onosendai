import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart' hide RichText;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/core/widgets/rich_text.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onDelete;

  const NoteCard({super.key, required this.note, this.onDelete});

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
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatDate(note.createdAt),
                  style: theme.mainFont.copyWith(
                    color: theme.dimmed,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (note.deleted)
            Text(
              '[note deleted]',
              style: theme.mainFont.copyWith(
                color: theme.dimmed,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            RichText(content: note.content, style: theme.mainFont),
          if (note.topics.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final topic in note.topics)
                  Text(
                    '#$topic',
                    style: theme.mainFont.copyWith(
                      color: theme.dimmed,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
          if (!note.deleted) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onDelete,
                tooltip: 'Delete note',
                icon: const Icon(LucideIcons.trash2),
                color: theme.dimmed,
                hoverColor: theme.foreground.withValues(alpha: 0.08),
                focusColor: theme.foreground.withValues(alpha: 0.08),
                splashColor: theme.foreground.withValues(alpha: 0.12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'undated';
    final local = date.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-$month-$day $hour:$minute';
  }
}
