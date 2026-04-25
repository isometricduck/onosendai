import 'package:flutter/material.dart';
import 'package:onosendai/core/theme/theme.dart';

class WritePage extends StatelessWidget {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Write',
                  style: theme.mainFont.copyWith(
                    color: theme.foreground,
                    fontSize: 18,
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
