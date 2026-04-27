import 'package:flutter/material.dart';
import 'package:onosendai/core/theme/theme.dart';

enum _WriteDestination { journal, feed }

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  var _destination = _WriteDestination.journal;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
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
                  minLines: 8,
                  maxLines: 12,
                  style: theme.mainFont.copyWith(color: theme.foreground),
                  cursorColor: theme.foreground,
                  decoration: InputDecoration(
                    hintText: 'What is happening?',
                    hintStyle: theme.mainFont.copyWith(color: theme.dimmed),
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
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        theme.foreground,
                      ),
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
                    child: Text(publishLabel),
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
