part of 'app_shell.dart';

class _DesktopShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool hasUnreadNotifications;

  const _DesktopShell({
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
