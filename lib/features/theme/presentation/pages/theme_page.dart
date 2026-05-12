import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class ThemePage extends ConsumerWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.cyberTheme;
    final selectedTheme = ref.watch(appThemeProvider);

    return Scaffold(
      backgroundColor: theme.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.eye, color: theme.headingText),
                    const SizedBox(width: 10),
                    Text(
                      'Themes',
                      style: theme.mainFont.copyWith(
                        color: theme.headingText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    for (final appTheme in AppThemeId.values)
                      _ThemeOption(
                        appTheme: appTheme,
                        selected: appTheme == selectedTheme,
                        onSelected: () => ref
                            .read(appThemeProvider.notifier)
                            .setTheme(appTheme),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final AppThemeId appTheme;
  final bool selected;
  final VoidCallback onSelected;

  const _ThemeOption({
    required this.appTheme,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final contentColor =
        selected ? theme.primaryButtonForeground : theme.headingText;

    return InkWell(
      onTap: onSelected,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              selected ? theme.primaryButtonBackground : Colors.transparent,
          border: Border.all(color: theme.cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(appTheme.theme.icon, color: contentColor),
            const SizedBox(height: 8),
            Text(
              appTheme.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.mainFont.copyWith(color: contentColor),
            ),
          ],
        ),
      ),
    );
  }
}
