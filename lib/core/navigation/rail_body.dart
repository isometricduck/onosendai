part of 'app_shell.dart';

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
