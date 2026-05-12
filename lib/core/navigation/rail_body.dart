import 'package:flutter/material.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class RailBody extends StatelessWidget {
  final double width;
  final bool extended;
  final List<AppDestination> destinations;
  final AppDestination selectedDestination;
  final ValueChanged<AppDestination> onSelectDestination;

  const RailBody({
    super.key,
    required this.width,
    required this.extended,
    required this.destinations,
    required this.selectedDestination,
    required this.onSelectDestination,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final railSelectedIndex = destinations.indexOf(selectedDestination);

    return Row(
      children: [
        SizedBox(
          width: width,
          child: NavigationRail(
            selectedIndex: railSelectedIndex,
            onDestinationSelected: (railIndex) {
              onSelectDestination(destinations[railIndex]);
            },
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
              for (final destination in destinations)
                NavigationRailDestination(
                  icon: DestinationIcon(
                    destination: destination,
                    hasUnreadNotifications: false,
                  ),
                  selectedIcon: DestinationIcon(
                    destination: destination,
                    hasUnreadNotifications: false,
                  ),
                  label: Text(destination.value.label),
                ),
            ],
          ),
        ),
        VerticalDivider(width: 1, color: theme.navBorder),
        //Expanded(child: _destinations[selectedIndex].page!),
      ],
    );
  }
}
