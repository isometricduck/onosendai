part of 'app_shell.dart';

class _MobileShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _MobileShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final navigationSelectedIndex = _navigationSelectedIndex(selectedIndex);

    return Scaffold(
      backgroundColor: theme.background,
      body: _destinations[selectedIndex].page!,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: isSelected ? theme.background : theme.dimmed,
            );
          }),
          labelTextStyle: WidgetStateProperty.all(
            theme.mainFont.copyWith(color: theme.foreground, fontSize: 12),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationSelectedIndex,
          onDestinationSelected: onDestinationSelected,
          backgroundColor: theme.background,
          indicatorColor: theme.dimmed,
          destinations: [
            for (final destination in _destinations.take(
              _primaryNavigationDestinationCount,
            ))
              NavigationDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.icon),
                label: '',
              ),
          ],
        ),
      ),
    );
  }
}
