import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/app_ui.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/core/navigation/mobile_destinations.dart';
import 'package:onosendai/core/navigation/mobile_shell.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class MenuBottomSheet extends StatelessWidget {
  final ValueChanged<int> onDestinationSelected;

  const MenuBottomSheet({super.key, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return Material(
      color: theme.navBackground,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (var index = 0; index < visibleDestinations.length; index++)
                  _MenuDestinationTile(
                    destination: visibleDestinations[index],
                    onTap: () {
                      Navigator.pop(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        onDestinationSelected(index);
                      });
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuDestinationTile extends StatelessWidget {
  final AppDestination destination;
  final VoidCallback onTap;

  const _MenuDestinationTile({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: theme.cardBorder)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(destination.value.icon, color: theme.headingText),
            const SizedBox(height: 8),
            Text(
              destination.value.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.mainFont.copyWith(color: theme.headingText),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeBottomSheet extends ConsumerWidget {
  const ThemeBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.cyberTheme;
    final selectedTheme = ref.watch(appThemeProvider);

    return Material(
      color: theme.navBackground,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
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
                    onSelected: () async {
                      await ref
                          .read(appThemeProvider.notifier)
                          .setTheme(appTheme);
                      if (context.mounted) Navigator.pop(context);
                    },
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
    final contentColor = selected
        ? theme.primaryButtonForeground
        : theme.headingText;

    return InkWell(
      onTap: onSelected,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? theme.primaryButtonBackground : Colors.transparent,
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