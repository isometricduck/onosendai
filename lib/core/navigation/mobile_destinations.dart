import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/navigation/app_shell.dart';
import 'package:onosendai/features/about/presentation/pages/about_page.dart';
import 'package:onosendai/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:onosendai/features/feed/presentation/pages/feed_page.dart';
import 'package:onosendai/features/journal/presentation/pages/journal_page.dart';
import 'package:onosendai/features/netiquette/presentation/pages/netiquette_page.dart';
import 'package:onosendai/features/notifications/presentation/pages/notifications_page.dart';
import 'package:onosendai/features/settings/presentation/pages/settings_page.dart';
import 'package:onosendai/features/write/presentation/pages/write_page.dart';

int _navigationSelectedIndex(int selectedIndex) {
  if (selectedIndex < _primaryNavigationDestinationCount) return selectedIndex;
  return _primaryNavigationDestinationCount - 1;
}

class _DestinationIcon extends StatelessWidget {
  final AppDestination destination;
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
        mobileDestinations.indexOf(destination) == _notificationsDestinationIndex;

    if (!showBadge) return icon;

    final theme = context.cyberTheme;

    return Badge(
      smallSize: 8,
      backgroundColor: theme.notificationUnreadIcon,
      child: icon,
    );
  }
}

const mobileDestinations = <AppDestination>[
  AppDestination(
    icon: LucideIcons.menuSquare,
    label: 'Feed',
    page: FeedPage(),
  ),
  AppDestination(icon: LucideIcons.pencil, label: 'Write', page: WritePage()),
  AppDestination.sheet(
    icon: LucideIcons.eye,
    label: 'Themes',
    sheet: _themeBottomSheet,
  ),
  AppDestination(
    icon: LucideIcons.bell,
    label: 'Notifs',
    page: NotificationsPage(),
  ),
  AppDestination.sheet(
    icon: LucideIcons.menu,
    label: 'Menu',
    sheet: _menuBottomSheet,
    includeInMenu: false,
  ),
  AppDestination(
    icon: LucideIcons.book,
    label: 'Journal',
    page: JournalPage(),
  ),
  AppDestination(
    icon: LucideIcons.bookmark,
    label: 'Bookmarks',
    page: BookmarksPage(),
  ),
  AppDestination(
    icon: LucideIcons.wrench,
    label: 'Settings',
    page: SettingsPage(),
  ),
  AppDestination(
    icon: LucideIcons.scale,
    label: 'Netiquette',
    page: NetiquettePage(),
  ),
  AppDestination(icon: LucideIcons.info, label: 'About', page: AboutPage()),
  AppDestination.dialog(
    icon: LucideIcons.logOut,
    label: 'Log out',
    dialog: _logoutDialog,
  ),
];