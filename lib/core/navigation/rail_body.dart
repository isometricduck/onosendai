part of 'app_shell.dart';

class _RailBody extends StatelessWidget {
  final double width;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;
  final bool hasUnreadNotifications;

  const _RailBody({
    required this.width,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.extended,
    required this.hasUnreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final navigationSelectedIndex = _navigationSelectedIndex(selectedIndex);

    return Row(
      children: [
        SizedBox(
          width: width,
          child: NavigationRail(
            selectedIndex: navigationSelectedIndex,
            onDestinationSelected: onDestinationSelected,
            extended: extended,
            backgroundColor: theme.navBackground,
            indicatorColor: theme.navIndicator,
            selectedIconTheme: IconThemeData(color: theme.navSelectedIcon),
            unselectedIconTheme: IconThemeData(color: theme.navUnselectedIcon),
            selectedLabelTextStyle: theme.mainFont.copyWith(
              color: theme.navSelectedLabel,
            ),
            unselectedLabelTextStyle: theme.mainFont.copyWith(
              color: theme.navUnselectedLabel,
            ),
            destinations: [
              for (final destination in _destinations.take(
                _primaryNavigationDestinationCount,
              ))
                NavigationRailDestination(
                  icon: _DestinationIcon(
                    destination: destination,
                    hasUnreadNotifications: hasUnreadNotifications,
                  ),
                  selectedIcon: _DestinationIcon(
                    destination: destination,
                    hasUnreadNotifications: hasUnreadNotifications,
                  ),
                  label: Text(destination.label),
                ),
            ],
          ),
        ),
        VerticalDivider(width: 1, color: theme.navBorder),
        Expanded(child: _destinations[selectedIndex].page!),
      ],
    );
  }
}
