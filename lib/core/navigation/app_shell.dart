import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/features/theme/classic_theme.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/about/presentation/pages/about_page.dart';
import 'package:onosendai/features/about/presentation/widgets/about_dialog.dart';
import 'package:onosendai/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:onosendai/features/feed/presentation/pages/eink_feed_page.dart';
import 'package:onosendai/features/feed/presentation/pages/feed_page.dart';
import 'package:onosendai/features/journal/presentation/pages/journal_page.dart';
import 'package:onosendai/features/login/presentation/logout_dialog.dart';
import 'package:onosendai/features/netiquette/presentation/pages/netiquette_page.dart';
import 'package:onosendai/features/notifications/presentation/pages/notifications_page.dart';
import 'package:onosendai/features/settings/presentation/pages/settings_page.dart';
import 'package:onosendai/features/write/presentation/pages/write_page.dart';

part 'desktop_shell.dart';
part 'destinations.dart';
part 'eink_shell.dart';
part 'mobile_shell.dart';
part 'rail_body.dart';
part 'tablet_shell.dart';

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
    if (const bool.fromEnvironment('EINK')) {
      return const _EinkShell();
    }

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
        decoration: BoxDecoration(border: Border.all(color: theme.cardBorder)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(destination.icon, color: theme.headingText),
            const SizedBox(height: 8),
            Text(
              destination.label,
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

class _ThemeBottomSheet extends ConsumerWidget {
  const _ThemeBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
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
    final theme = context.theme;
    final contentColor = selected ? theme.primaryButtonForeground : theme.headingText;

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
