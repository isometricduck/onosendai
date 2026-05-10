import 'package:flutter/material.dart';
import 'package:onosendai/core/navigation/rail_body.dart';
import 'package:onosendai/core/navigation/rail_destinations.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class DesktopShell extends StatelessWidget {

  const DesktopShell({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return Scaffold(
      backgroundColor: theme.pageBackground,
      body: SafeArea(
        child: RailBody(
          width: 220,
          destinations: railDestinations,
        ),
      ),
    );
  }
}
