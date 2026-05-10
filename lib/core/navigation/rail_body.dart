import 'package:flutter/material.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class RailBody extends StatelessWidget {
  final double width;
  final List<AppDestination> destinations;

  const RailBody({super.key, 
    required this.width,
    required this.destinations
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final railSelectedIndex = 0;
        //railDestinations.indexWhere((e) => e == selectedIndex);

    return Row(
      children: [
        SizedBox(
          width: width,
          child: NavigationRail(
            selectedIndex: railSelectedIndex,
            /*onDestinationSelected: (railIndex) {
              onDestinationSelected(railDestinations[railIndex].$1);
            },*/
            //extended: extended,
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
