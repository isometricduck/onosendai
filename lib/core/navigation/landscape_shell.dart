import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/core/navigation/rail_body.dart';
import 'package:onosendai/core/navigation/shell_effect.dart';
import 'package:onosendai/core/providers/nav_provider.dart';
import 'package:onosendai/features/about/presentation/pages/about_page.dart';
import 'package:onosendai/features/about/presentation/widgets/about_dialog.dart';
import 'package:onosendai/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:onosendai/features/feed/presentation/pages/feed_page.dart';
import 'package:onosendai/features/journal/presentation/pages/journal_page.dart';
import 'package:onosendai/features/login/presentation/logout_dialog.dart';
import 'package:onosendai/features/netiquette/presentation/pages/netiquette_page.dart';
import 'package:onosendai/features/notifications/presentation/pages/notifications_page.dart';
import 'package:onosendai/features/profiles/presentation/pages/user_profile_page.dart';
import 'package:onosendai/features/settings/presentation/pages/settings_page.dart';
import 'package:onosendai/features/feed/presentation/pages/post_detail_page.dart';
import 'package:onosendai/features/feed/presentation/riverpod/selected_post_provider.dart';
import 'package:onosendai/features/theme/presentation/pages/theme_page.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/write/presentation/pages/write_page.dart';

const _landscapeDestinations = <AppDestination>[
  AppDestination.feed,
  AppDestination.write,
  AppDestination.themes,
  AppDestination.notifications,
  AppDestination.journal,
  AppDestination.bookmarks,
  AppDestination.profile,
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
    ref.read(selectedPostProvider.notifier).state = null;
    final nav = ref.read(navNotifierProvider.notifier);

    switch (destination) {
      case AppDestination.menu:
        nav.showEffect(ShellEffect.menu);
        return;
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
      case AppDestination.profile:
        return UserProfilePage();
      case AppDestination.themes:
        return ThemePage();
      case AppDestination.settings:
        return SettingsPage();
      case AppDestination.netiquette:
        return NetiquettePage();
      case AppDestination.about:
        return AboutPage();

      case AppDestination.menu:
      case AppDestination.logout:
        throw StateError('$destination is not a desktop page');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.cyberTheme;
    final navState = ref.watch(navNotifierProvider);
    final selectedPost = ref.watch(selectedPostProvider);

    ref.listen(navNotifierProvider, (previous, next) {
      final effect = next.pendingEffect;
      if (effect == null) return;

      switch (effect) {
        case ShellEffect.themes:
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
            Expanded(
              child: selectedPost != null
                  ? PostDetailPage(
                      post: selectedPost.$1,
                      initiallyReplying: selectedPost.$2,
                      onClose: () =>
                          ref.read(selectedPostProvider.notifier).state = null,
                    )
                  : _buildPageForDestination(navState.destination),
            ),
          ],
        ),
      ),
    );
  }
}
