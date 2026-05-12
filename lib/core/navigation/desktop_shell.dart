import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/core/navigation/rail_body.dart';
import 'package:onosendai/core/navigation/shell_effect.dart';
import 'package:onosendai/core/navigation/themes_sheet.dart';
import 'package:onosendai/core/providers/nav_provider.dart';
import 'package:onosendai/features/about/presentation/widgets/about_dialog.dart';
import 'package:onosendai/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:onosendai/features/feed/presentation/pages/feed_page.dart';
import 'package:onosendai/features/journal/presentation/pages/journal_page.dart';
import 'package:onosendai/features/login/presentation/logout_dialog.dart';
import 'package:onosendai/features/netiquette/presentation/pages/netiquette_page.dart';
import 'package:onosendai/features/notifications/presentation/pages/notifications_page.dart';
import 'package:onosendai/features/settings/presentation/pages/settings_page.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/write/presentation/pages/write_page.dart';

const _landscapeDestinations = <AppDestination>[
  AppDestination.feed,
  AppDestination.write,
  AppDestination.themes,
  AppDestination.notifications,
  AppDestination.journal,
  AppDestination.bookmarks,
  AppDestination.settings,
  AppDestination.netiquette,
  AppDestination.about,
  AppDestination.logout,
];

class LandscapeShell extends ConsumerWidget {
  final int railWidth;
  final bool extended;

  const LandscapeShell({
    super.key,
    required this.railWidth,
    required this.extended,
  });

  void selectDestination(WidgetRef ref, AppDestination destination) {
    final nav = ref.read(navNotifierProvider.notifier);

    switch (destination) {
      case AppDestination.themes:
        nav.showEffect(ShellEffect.themes);
        return;
      case AppDestination.menu:
        nav.showEffect(ShellEffect.menu);
        return;
      case AppDestination.about:
        nav.showEffect(ShellEffect.about);
      case AppDestination.logout:
        nav.showEffect(ShellEffect.logout);
        return;
      default:
        nav.goTo(destination);
    }
  }

  Widget _buildPageForDestination(AppDestination destination) {
    switch (destination) {
      case AppDestination.feed:
        return FeedPage();
      case AppDestination.write:
        return WritePage();
      case AppDestination.notifications:
        return NotificationsPage();
      case AppDestination.journal:
        return JournalPage();
      case AppDestination.bookmarks:
        return BookmarksPage();
      case AppDestination.settings:
        return SettingsPage();
      case AppDestination.netiquette:
        return NetiquettePage();

      case AppDestination.about:
      case AppDestination.menu:
      case AppDestination.themes:
      case AppDestination.logout:
        throw StateError('$destination is not a mobile page');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.cyberTheme;
    final navState = ref.watch(navNotifierProvider);

    ref.listen(navNotifierProvider, (previous, next) {
      final effect = next.pendingEffect;
      if (effect == null) return;

      switch (effect) {
        case ShellEffect.themes:
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => ThemeBottomSheet(),
          );
          break;
        case ShellEffect.menu:
          break;
        case ShellEffect.about:
          showDialog<void>(
            context: context,
            builder: (context) => OnosendaiAboutDialog(),
          );
          break;
        case ShellEffect.logout:
          showDialog<void>(
            context: context,
            builder: (context) => LogoutDialog(),
          );
          break;
      }
    });

    return Scaffold(
      backgroundColor: theme.pageBackground,
      body: SafeArea(
        child: Row(
          children: [
            RailBody(
              width: 220,
              extended: true,
              destinations: _landscapeDestinations,
              selectedDestination: navState.destination,
              onSelectDestination: (destination) {
                selectDestination(ref, destination);
              },
            ),
            Expanded(child: _buildPageForDestination(navState.destination)),
          ],
        ),
      ),
    );
  }
}
