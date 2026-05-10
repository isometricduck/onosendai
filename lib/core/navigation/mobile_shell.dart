import 'package:flutter/widgets.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class MobileShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool hasUnreadNotifications;

  const MobileShell({super.key, 
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.hasUnreadNotifications,
  });

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
    final theme = context.cyberTheme;
    final navigationSelectedIndex = _navigationSelectedIndex(selectedIndex);

    return Scaffold(
      backgroundColor: theme.pageBackground,
      body: _destinations[selectedIndex].page!,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: isSelected ? theme.navBackground : theme.navUnselectedIcon,
            );
          }),
          labelTextStyle: WidgetStateProperty.all(
            theme.mainFont.copyWith(
              color: theme.navSelectedLabel,
              fontSize: 12,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationSelectedIndex,
          onDestinationSelected: onDestinationSelected,
          backgroundColor: theme.navBackground,
          indicatorColor: theme.navIndicator,
          destinations: [
            for (final destination in _destinations.take(
              _primaryNavigationDestinationCount,
            ))
              NavigationDestination(
                icon: _DestinationIcon(
                  destination: destination,
                  hasUnreadNotifications: hasUnreadNotifications,
                ),
                selectedIcon: _DestinationIcon(
                  destination: destination,
                  hasUnreadNotifications: hasUnreadNotifications,
                ),
                label: '',
              ),
          ],
        ),
      ),
    );
  }
}
