part of 'app_shell.dart';

class _TabletShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool hasUnreadNotifications;

  const _TabletShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.hasUnreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.pageBackground,
      body: SafeArea(
        child: _RailBody(
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
