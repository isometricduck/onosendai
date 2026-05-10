import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onosendai/core/navigation/rail_destinations.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class RailBody extends StatelessWidget {
  final double width;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;
  final bool hasUnreadNotifications;

  const RailBody({super.key, 
    required this.width,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.extended,
    required this.hasUnreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final railSelectedIndex =
        railDestinations.indexWhere((e) => e == selectedIndex);

    return Row(
      children: [
        SizedBox(
          width: width,
          child: NavigationRail(
            selectedIndex: railSelectedIndex,
            onDestinationSelected: (railIndex) {
              onDestinationSelected(railDestinations[railIndex].$1);
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
              for (final (_, destination) in _railDestinations)
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
