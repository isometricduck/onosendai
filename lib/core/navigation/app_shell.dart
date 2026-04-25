import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/feed/presentation/pages/feed_page.dart';
import 'package:onosendai/features/settings/presentation/pages/settings_page.dart';
import 'package:onosendai/features/write/presentation/pages/write_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var _selectedIndex = 0;

  void _selectDestination(int index) {
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
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const _AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}

const _destinations = <_AppDestination>[
  _AppDestination(
    label: 'Feed',
    icon: LucideIcons.menuSquare,
    selectedIcon: LucideIcons.menuSquare,
    page: FeedPage(),
  ),
  _AppDestination(
    label: 'Write',
    icon: LucideIcons.pencil,
    selectedIcon: LucideIcons.pencil,
    page: WritePage(),
  ),
  _AppDestination(
    label: 'Settings',
    icon: LucideIcons.wrench,
    selectedIcon: LucideIcons.wrench,
    page: SettingsPage(),
  ),
];

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
      appBar: AppBar(
        title: Text(_destinations[selectedIndex].label),
        backgroundColor: theme.background,
        foregroundColor: theme.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: _destinations[selectedIndex].page,
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
          indicatorColor: theme.code,
          destinations: [
            for (final destination in _destinations)
              NavigationDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.selectedIcon),
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
          indicatorColor: theme.code,
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
                selectedIcon: Icon(destination.selectedIcon),
                label: Text(destination.label),
              ),
          ],
        ),
        VerticalDivider(width: 1, color: theme.border),
        Expanded(child: _destinations[selectedIndex].page),
      ],
    );
  }
}
