import 'package:flutter/material.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/core/navigation/mobile_shell.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class MenuBottomSheet extends StatelessWidget {
  final ValueChanged<AppDestination> onDestinationSelected;

  const MenuBottomSheet({super.key, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

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
              for (var index = 0; index < hiddenDestinations.length; index++)
                _MenuDestinationTile(
                  destination: hiddenDestinations[index],
                  onTap: () {
                    Navigator.pop(context);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onDestinationSelected(hiddenDestinations[index]);
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
  final AppDestination destination;
  final VoidCallback onTap;

  const _MenuDestinationTile({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: theme.cardBorder)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(destination.value.icon, color: theme.headingText),
            const SizedBox(height: 8),
            Text(
              destination.value.label,
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
