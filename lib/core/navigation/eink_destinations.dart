import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/navigation/app_shell.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/features/feed/presentation/pages/eink_feed_page.dart';

const einkDestinations = <AppDestination>[
  AppDestination(
    icon: LucideIcons.menuSquare,
    label: 'Feed',
    page: EinkFeedPage(),
  ),
  AppDestination(
    icon: LucideIcons.bookmark,
    label: 'Bookmarks',
    page: EinkFeedPage(source: EinkFeedSource.bookmarks),
  ),
  AppDestination.dialog(
    icon: LucideIcons.info,
    label: 'About',
    dialog: _aboutDialog,
  ),
  AppDestination.dialog(
    icon: LucideIcons.logOut,
    label: 'Log out',
    dialog: _logoutDialog,
  ),
];