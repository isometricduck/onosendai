import 'package:flutter/material.dart';
import 'package:onosendai/core/theme/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                  'Settings',
                  style: theme.mainFont.copyWith(
                    color: theme.foreground,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Settings will live here.',
                  style: theme.mainFont.copyWith(color: theme.dimmed),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
