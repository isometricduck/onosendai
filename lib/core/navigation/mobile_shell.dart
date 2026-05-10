import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/core/providers/nav_provider.dart';
import 'package:onosendai/features/about/presentation/pages/about_page.dart';
import 'package:onosendai/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:onosendai/features/feed/presentation/pages/feed_page.dart';
import 'package:onosendai/features/journal/presentation/pages/journal_page.dart';
import 'package:onosendai/features/netiquette/presentation/pages/netiquette_page.dart';
import 'package:onosendai/features/notifications/presentation/pages/notifications_page.dart';
import 'package:onosendai/features/settings/presentation/pages/settings_page.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/write/presentation/pages/write_page.dart';

const visibleDestinations = <AppDestination>[
  AppDestination.feed,
  AppDestination.write,
  AppDestination.themes,
  AppDestination.notifications,
];

const hiddenDestinations = <AppDestination>[
  AppDestination.menu,
  AppDestination.journal,
  AppDestination.bookmarks,
  AppDestination.settings,
  AppDestination.netiquette,
  AppDestination.about,
  AppDestination.logout,
];

class MobileShell extends ConsumerWidget {

  const MobileShell({super.key});

  Widget getPage(AppDestination destination) {
    switch(destination) {
      case AppDestination.feed:
        return FeedPage();
      case AppDestination.write:
        return WritePage();
      case AppDestination.themes:
        return FeedPage();
      case AppDestination.notifications:
        return NotificationsPage();
      case AppDestination.menu:
        return FeedPage();
      case AppDestination.journal:
        return JournalPage();
      case AppDestination.bookmarks:
        return BookmarksPage();
      case AppDestination.settings:
        return SettingsPage();
      case AppDestination.netiquette:
        return NetiquettePage();
      case AppDestination.about:
        return AboutPage();
      case AppDestination.logout:
        return AboutPage();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.cyberTheme;
    final navState = ref.read(navNotifierProvider);

    return Scaffold(
      backgroundColor: theme.pageBackground,
      body: getPage(navState.destination),
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
          selectedIndex: 0,
          backgroundColor: theme.navBackground,
          indicatorColor: theme.navIndicator,
          destinations: [
            for (final destination in visibleDestinations)
              NavigationDestination(
                icon: DestinationIcon(
                  destination: destination,
                  hasUnreadNotifications: false,
                ),
                selectedIcon: DestinationIcon(
                  destination: destination,
                  hasUnreadNotifications: false,
                ),
                label: '',
              ),
          ],
        ),
      ),
    );
  }
}
