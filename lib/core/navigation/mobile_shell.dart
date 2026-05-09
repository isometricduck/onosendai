part of 'app_shell.dart';

class _MobileShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool hasUnreadNotifications;

  const _MobileShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.hasUnreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
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
