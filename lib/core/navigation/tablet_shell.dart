import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onosendai/core/navigation/rail_body.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class TabletShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool hasUnreadNotifications;

  const TabletShell({super.key, 
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.hasUnreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return Scaffold(
      backgroundColor: theme.pageBackground,
      body: SafeArea(
        child: RailBody(
          width: 100,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          extended: false,
          hasUnreadNotifications: hasUnreadNotifications,
        ),
      ),
    );
  }
}
