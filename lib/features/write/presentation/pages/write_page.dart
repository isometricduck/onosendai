import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/journal/presentation/riverpod/journal_providers.dart';

enum _WriteDestination { journal, feed }

class WritePage extends ConsumerStatefulWidget {
  const WritePage({super.key});

  @override
  ConsumerState<WritePage> createState() => _WritePageState();
}

class _WritePageState extends ConsumerState<WritePage> {
  final _contentController = TextEditingController();
  var _destination = _WriteDestination.journal;
  var _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final content = _contentController.text.trim();
    if (content.isEmpty || _isSubmitting) return;
    if (_destination == _WriteDestination.feed &&
        !await _confirmFeedPublish()) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final client = ref.read(cyberspaceClientProvider);
      switch (_destination) {
        case _WriteDestination.journal:
          await client.notes.create(content: content);
          ref.invalidate(journalNotifierProvider);
        case _WriteDestination.feed:
          await client.posts.create(content: content, isPublic: true);
          ref.invalidate(feedNotifierProvider);
      }

      _contentController.clear();
      if (!mounted) return;
      setState(() {});
      _showMessage(switch (_destination) {
        _WriteDestination.journal => 'Note saved.',
        _WriteDestination.feed => 'Post published.',
      });
    } catch (error) {
      if (!mounted) return;
      _showMessage(_errorMessage(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _errorMessage(Object error) {
    if (error is CyberspaceClientException) return error.message;
    return 'Something went wrong.';
  }

  void _showMessage(String message) {
    final theme = context.theme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.mainFont.copyWith(color: theme.background),
        ),
        backgroundColor: theme.foreground,
      ),
    );
  }

  Future<bool> _confirmFeedPublish() async {
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
              'Publish to Feed?',
              style: theme.mainFont.copyWith(
                color: theme.foreground,
                fontSize: 18,
              ),
            ),
            content: Text(
              'This post will be visible in the public feed.',
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
                child: const Text('Publish'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final canSubmit = _contentController.text.trim().isNotEmpty;
    final publishLabel = switch (_destination) {
      _WriteDestination.journal => 'Save Note',
      _WriteDestination.feed => 'Publish to Feed',
    };

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Write',
                      style: theme.mainFont.copyWith(
                        color: theme.foreground,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SegmentedButton<_WriteDestination>(
                          showSelectedIcon: false,
                          selected: {_destination},
                          onSelectionChanged: (selection) {
                            setState(() => _destination = selection.first);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    return theme.foreground;
                                  }
                                  return theme.background;
                                }),
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    return theme.background;
                                  }
                                  return theme.foreground;
                                }),
                            side: WidgetStateProperty.all(
                              BorderSide(color: theme.border),
                            ),
                            shape: WidgetStateProperty.all(
                              const RoundedRectangleBorder(),
                            ),
                            textStyle: WidgetStateProperty.all(
                              theme.mainFont.copyWith(fontSize: 13),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          segments: const [
                            ButtonSegment(
                              value: _WriteDestination.journal,
                              label: Text('Journal'),
                            ),
                            ButtonSegment(
                              value: _WriteDestination.feed,
                              label: Text('Feed'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _contentController,
                  minLines: 8,
                  maxLines: 12,
                  onChanged: (_) => setState(() {}),
                  style: theme.mainFont.copyWith(color: theme.foreground),
                  cursorColor: theme.foreground,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.foreground),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: canSubmit && !_isSubmitting ? _submit : null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return theme.dimmed;
                        }
                        return theme.foreground;
                      }),
                      foregroundColor: WidgetStateProperty.all(
                        theme.background,
                      ),
                      overlayColor: WidgetStateProperty.all(
                        theme.background.withValues(alpha: 0.08),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: theme.foreground),
                        ),
                      ),
                      textStyle: WidgetStateProperty.all(theme.mainFont),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.background,
                            ),
                          )
                        : Text(publishLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
