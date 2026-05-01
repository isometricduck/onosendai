import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/feed/presentation/pages/feed_page.dart';
import 'package:onosendai/features/journal/presentation/pages/journal_page.dart';
import 'package:onosendai/features/settings/presentation/pages/settings_page.dart';
import 'package:onosendai/features/write/presentation/pages/write_page.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  var _selectedIndex = 0;

  void _selectDestination(int index) {
    final destination = _destinations[index];

    if (destination.sheet != null) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: destination.sheet!,
      );
      return;
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return _MobileShell(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectDestination,
      );
    }

    if (width <= 840) {
      return _TabletShell(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectDestination,
      );
    }

    return _DesktopShell(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _selectDestination,
    );
  }
}

class _AppDestination {
  final IconData icon;
  final String label;
  final Widget? page;
  final WidgetBuilder? sheet;

  const _AppDestination({
    required this.icon,
    required this.label,
    required this.page,
  }) : sheet = null;

  const _AppDestination.sheet({
    required this.icon,
    required this.label,
    required this.sheet,
  }) : page = null;
}

const _destinations = <_AppDestination>[
  _AppDestination(
    icon: LucideIcons.menuSquare,
    label: 'Feed',
    page: FeedPage(),
  ),
  _AppDestination(icon: LucideIcons.pencil, label: 'Write', page: WritePage()),
  _AppDestination(
    icon: LucideIcons.book,
    label: 'Journal',
    page: JournalPage(),
  ),
  _AppDestination.sheet(
    icon: LucideIcons.eye,
    label: 'Themes',
    sheet: _themeBottomSheet,
  ),
  _AppDestination(
    icon: LucideIcons.wrench,
    label: 'Settings',
    page: SettingsPage(),
  ),
];

Widget _themeBottomSheet(BuildContext context) {
  return const _ThemeBottomSheet();
}

class _ThemeBottomSheet extends ConsumerWidget {
  const _ThemeBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final selectedTheme = ref.watch(appThemeProvider);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.9,
      child: Material(
        color: theme.background,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
    final theme = context.theme;
    final contentColor = selected ? theme.background : theme.dimmed;

    return SizedBox(
      height: 52,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 3, child: ColoredBox(color: theme.background)),
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: onSelected,
              child: ColoredBox(
                color: selected ? theme.foreground : Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(appTheme.theme.icon, color: contentColor),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          appTheme.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: theme.mainFont.copyWith(color: contentColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(flex: 3, child: ColoredBox(color: theme.background)),
        ],
      ),
    );
  }
}

class _MobileShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _MobileShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.background,
      body: _destinations[selectedIndex].page!,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: isSelected ? theme.foreground : theme.dimmed,
            );
          }),
          labelTextStyle: WidgetStateProperty.all(
            theme.mainFont.copyWith(color: theme.foreground, fontSize: 12),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          backgroundColor: theme.background,
          indicatorColor: theme.dimmed,
          destinations: [
            for (final destination in _destinations)
              NavigationDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.icon),
                label: destination.label,
              ),
          ],
        ),
      ),
    );
  }
}

class _TabletShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _TabletShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: _RailBody(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          extended: false,
        ),
      ),
    );
  }
}

class _DesktopShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _DesktopShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: _RailBody(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          extended: true,
        ),
      ),
    );
  }
}

class _RailBody extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  const _RailBody({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.extended,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          extended: extended,
          backgroundColor: theme.background,
          indicatorColor: theme.dimmed,
          selectedIconTheme: IconThemeData(color: theme.foreground),
          unselectedIconTheme: IconThemeData(color: theme.dimmed),
          selectedLabelTextStyle: theme.mainFont.copyWith(
            color: theme.foreground,
          ),
          unselectedLabelTextStyle: theme.mainFont.copyWith(
            color: theme.dimmed,
          ),
          destinations: [
            for (final destination in _destinations)
              NavigationRailDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.icon),
                label: Text(destination.label),
              ),
          ],
        ),
        VerticalDivider(width: 1, color: theme.border),
        Expanded(child: _destinations[selectedIndex].page!),
      ],
    );
  }
}
