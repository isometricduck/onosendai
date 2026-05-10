import 'package:flutter/material.dart';
import 'package:onosendai/core/navigation/rail_body.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class DesktopShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool hasUnreadNotifications;

  const DesktopShell({super.key, 
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
          width: 220,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          extended: true,
          hasUnreadNotifications: hasUnreadNotifications,
        ),
      ),
    );
  }
}
