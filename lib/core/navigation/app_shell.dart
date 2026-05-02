import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:onosendai/features/feed/presentation/pages/feed_page.dart';
import 'package:onosendai/features/journal/presentation/pages/journal_page.dart';
import 'package:onosendai/features/login/presentation/logout_dialog.dart';
import 'package:onosendai/features/netiquette/presentation/pages/netiquette_page.dart';
import 'package:onosendai/features/notifications/presentation/pages/notifications_page.dart';
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
        builder: (context) => destination.sheet!(context, _selectDestination),
      );
      return;
    }

    if (destination.dialog != null) {
      showDialog<void>(
        context: context,
        builder: (context) => destination.dialog!(context, _selectDestination),
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

typedef _AppDestinationSheetBuilder =
    Widget Function(
      BuildContext context,
      ValueChanged<int> onDestinationSelected,
    );
typedef _AppDestinationDialogBuilder =
    Widget Function(
      BuildContext context,
      ValueChanged<int> onDestinationSelected,
    );

class _AppDestination {
  final IconData icon;
  final String label;
  final Widget? page;
  final _AppDestinationSheetBuilder? sheet;
  final _AppDestinationDialogBuilder? dialog;
  final bool includeInMenu;

  const _AppDestination({
    required this.icon,
    required this.label,
    required this.page,
  }) : sheet = null,
       dialog = null,
       includeInMenu = true;

  const _AppDestination.sheet({
    required this.icon,
    required this.label,
    required this.sheet,
    this.includeInMenu = true,
  }) : page = null,
       dialog = null;

  const _AppDestination.dialog({
    required this.icon,
    required this.label,
    required this.dialog,
  }) : page = null,
       sheet = null,
       includeInMenu = true;
}

const _destinations = <_AppDestination>[
  _AppDestination(
    icon: LucideIcons.menuSquare,
    label: 'Feed',
    page: FeedPage(),
  ),
  _AppDestination(icon: LucideIcons.pencil, label: 'Write', page: WritePage()),
  _AppDestination.sheet(
    icon: LucideIcons.eye,
    label: 'Themes',
    sheet: _themeBottomSheet,
  ),
  _AppDestination(
    icon: LucideIcons.bell,
    label: 'Notifications',
    page: NotificationsPage(),
  ),
  _AppDestination.sheet(
    icon: LucideIcons.menu,
    label: 'Menu',
    sheet: _menuBottomSheet,
    includeInMenu: false,
  ),
  _AppDestination(
    icon: LucideIcons.book,
    label: 'Journal',
    page: JournalPage(),
  ),
  _AppDestination(
    icon: LucideIcons.bookmark,
    label: 'Bookmarks',
    page: BookmarksPage(),
  ),
  _AppDestination(
    icon: LucideIcons.scale,
    label: 'Netiquette',
    page: NetiquettePage(),
  ),
  _AppDestination.dialog(
    icon: LucideIcons.logOut,
    label: 'Log out',
    dialog: _logoutDialog,
  ),
];

const _primaryNavigationDestinationCount = 5;

int _navigationSelectedIndex(int selectedIndex) {
  if (selectedIndex < _primaryNavigationDestinationCount) return selectedIndex;
  return _primaryNavigationDestinationCount - 1;
}

Widget _logoutDialog(
  BuildContext context,
  ValueChanged<int> onDestinationSelected,
) {
  return const LogoutDialog();
}

Widget _menuBottomSheet(
  BuildContext context,
  ValueChanged<int> onDestinationSelected,
) {
  return _MenuBottomSheet(onDestinationSelected: onDestinationSelected);
}

Widget _themeBottomSheet(
  BuildContext context,
  ValueChanged<int> onDestinationSelected,
) {
  return const _ThemeBottomSheet();
}

class _MenuBottomSheet extends StatelessWidget {
  final ValueChanged<int> onDestinationSelected;

  const _MenuBottomSheet({required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Material(
      color: theme.background,
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
              for (var index = 0; index < _destinations.length; index++)
                if (_destinations[index].includeInMenu)
                  _MenuDestinationTile(
                    destination: _destinations[index],
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
  final _AppDestination destination;
  final VoidCallback onTap;

  const _MenuDestinationTile({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: theme.border)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(destination.icon, color: theme.foreground),
            const SizedBox(height: 8),
            Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.mainFont.copyWith(color: theme.foreground),
            ),
          ],
        ),
      ),
    );
  }
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
    final navigationSelectedIndex = _navigationSelectedIndex(selectedIndex);

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
          selectedIndex: navigationSelectedIndex,
          onDestinationSelected: onDestinationSelected,
          backgroundColor: theme.background,
          indicatorColor: theme.dimmed,
          destinations: [
            for (final destination in _destinations.take(
              _primaryNavigationDestinationCount,
            ))
              NavigationDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.icon),
                label: '',
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
    final navigationSelectedIndex = _navigationSelectedIndex(selectedIndex);

    return Row(
      children: [
        NavigationRail(
          selectedIndex: navigationSelectedIndex,
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
            for (final destination in _destinations.take(
              _primaryNavigationDestinationCount,
            ))
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
