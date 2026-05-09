part of 'app_shell.dart';

typedef _AppDestinationSheetBuilder =
    Widget Function(
      BuildContext context,
      ValueChanged<int> onDestinationSelected,
    );
typedef _AppDestinationDialogBuilder =
    Widget Function(
      BuildContext context,
      ValueChanged<int> onDestinationSelected,
    );

// This class is asking for a refactor
class _AppDestination {
  final IconData icon;
  final String label;
  final Widget? page;
  final _AppDestinationSheetBuilder? sheet;
  final _AppDestinationDialogBuilder? dialog;
  final bool includeInMenu;

  const _AppDestination({
    required this.icon,
    required this.label,
    required this.page,
  }) : sheet = null,
       dialog = null,
       includeInMenu = true;

  const _AppDestination.sheet({
    required this.icon,
    required this.label,
    required this.sheet,
    this.includeInMenu = true,
  }) : page = null,
       dialog = null;

  const _AppDestination.dialog({
    required this.icon,
    required this.label,
    required this.dialog,
  }) : page = null,
       sheet = null,
       includeInMenu = true;
}

const _destinations = <_AppDestination>[
  _AppDestination(
    icon: LucideIcons.menuSquare,
    label: 'Feed',
    page: FeedPage(),
  ),
  _AppDestination(icon: LucideIcons.pencil, label: 'Write', page: WritePage()),
  _AppDestination.sheet(
    icon: LucideIcons.eye,
    label: 'Themes',
    sheet: _themeBottomSheet,
  ),
  _AppDestination(
    icon: LucideIcons.bell,
    label: 'Notifications',
    page: NotificationsPage(),
  ),
  _AppDestination.sheet(
    icon: LucideIcons.menu,
    label: 'Menu',
    sheet: _menuBottomSheet,
    includeInMenu: false,
  ),
  _AppDestination(
    icon: LucideIcons.book,
    label: 'Journal',
    page: JournalPage(),
  ),
  _AppDestination(
    icon: LucideIcons.bookmark,
    label: 'Bookmarks',
    page: BookmarksPage(),
  ),
  _AppDestination(
    icon: LucideIcons.wrench,
    label: 'Settings',
    page: SettingsPage(),
  ),
  _AppDestination(
    icon: LucideIcons.scale,
    label: 'Netiquette',
    page: NetiquettePage(),
  ),
  _AppDestination(icon: LucideIcons.info, label: 'About', page: AboutPage()),
  _AppDestination.dialog(
    icon: LucideIcons.logOut,
    label: 'Log out',
    dialog: _logoutDialog,
  ),
];

const _primaryNavigationDestinationCount = 5;
const _notificationsDestinationIndex = 3;

int _navigationSelectedIndex(int selectedIndex) {
  if (selectedIndex < _primaryNavigationDestinationCount) return selectedIndex;
  return _primaryNavigationDestinationCount - 1;
}

class _DestinationIcon extends StatelessWidget {
  final _AppDestination destination;
  final bool hasUnreadNotifications;

  const _DestinationIcon({
    required this.destination,
    required this.hasUnreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final icon = Icon(destination.icon);
    final showBadge =
        hasUnreadNotifications &&
        _destinations.indexOf(destination) == _notificationsDestinationIndex;

    if (!showBadge) return icon;

    final theme = context.theme;

    return Badge(
      smallSize: 8,
      backgroundColor: theme.notificationUnreadIcon,
      child: icon,
    );
  }
}

const _einkDestinations = <_AppDestination>[
  _AppDestination(
    icon: LucideIcons.menuSquare,
    label: 'Feed',
    page: EinkFeedPage(),
  ),
  _AppDestination(
    icon: LucideIcons.bookmark,
    label: 'Bookmarks',
    page: EinkFeedPage(source: EinkFeedSource.bookmarks),
  ),
  _AppDestination.dialog(
    icon: LucideIcons.info,
    label: 'About',
    dialog: _aboutDialog,
  ),
  _AppDestination.dialog(
    icon: LucideIcons.logOut,
    label: 'Log out',
    dialog: _logoutDialog,
  ),
];
