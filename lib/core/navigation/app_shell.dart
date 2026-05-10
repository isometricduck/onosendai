import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/navigation/desktop_shell.dart';
import 'package:onosendai/core/navigation/eink_shell.dart';
import 'package:onosendai/core/navigation/mobile_shell.dart';
import 'package:onosendai/core/navigation/tablet_shell.dart';
import 'package:onosendai/features/theme/classic_theme.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/about/presentation/pages/about_page.dart';
import 'package:onosendai/features/about/presentation/widgets/about_dialog.dart';
import 'package:onosendai/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:onosendai/features/feed/presentation/pages/eink_feed_page.dart';
import 'package:onosendai/features/feed/presentation/pages/feed_page.dart';
import 'package:onosendai/features/journal/presentation/pages/journal_page.dart';
import 'package:onosendai/features/login/presentation/logout_dialog.dart';
import 'package:onosendai/features/netiquette/presentation/pages/netiquette_page.dart';
import 'package:onosendai/features/notifications/presentation/riverpod/notifications_providers.dart';
import 'package:onosendai/features/notifications/presentation/pages/notifications_page.dart';
import 'package:onosendai/features/settings/presentation/pages/settings_page.dart';
import 'package:onosendai/features/write/presentation/pages/write_page.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  Widget build(BuildContext context) {
    if (const bool.fromEnvironment('EINK')) {
      return const EinkShell();
    }

    final hasUnreadNotifications =
        (ref.watch(notificationsNotifierProvider).valueOrNull?.unreadCount ??
            0) >
        0;
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return MobileShell(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectDestination,
        hasUnreadNotifications: hasUnreadNotifications,
      );
    }

    if (width < 1280) {
      return TabletShell(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectDestination,
        hasUnreadNotifications: hasUnreadNotifications,
      );
    }

    return DesktopShell(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _selectDestination,
      hasUnreadNotifications: hasUnreadNotifications,
    );
  }
}

Widget _logoutDialog(
  BuildContext context,
  ValueChanged<int> onDestinationSelected,
) {
  return const LogoutDialog();
}

Widget _menuBottomSheet(
  BuildContext context,
  ValueChanged<int> onDestinationSelected,
) {
  return _MenuBottomSheet(onDestinationSelected: onDestinationSelected);
}

Widget _themeBottomSheet(
  BuildContext context,
  ValueChanged<int> onDestinationSelected,
) {
  return const _ThemeBottomSheet();
}
