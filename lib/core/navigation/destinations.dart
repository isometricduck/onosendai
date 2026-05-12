import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class DestinationIcon extends StatelessWidget {
  final AppDestination destination;
  final bool hasUnreadNotifications;

  const DestinationIcon({super.key, 
    required this.destination,
    required this.hasUnreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final icon = Icon(destination.value.icon);
    final showBadge =
        hasUnreadNotifications &&
        destination == AppDestination.notifications;

    if (!showBadge) return icon;

    final theme = context.cyberTheme;

    return Badge(
      smallSize: 8,
      backgroundColor: theme.notificationUnreadIcon,
      child: icon,
    );
  }
}

class Destination {
  final IconData icon;
  final String label;

  const Destination({required this.icon, required this.label});
}

enum AppDestination {
  feed(Destination(
    icon: LucideIcons.menuSquare,
    label: 'Feed'
  )),
  write(Destination(icon: LucideIcons.pencil, label: 'Write')),
  themes(Destination(
    icon: LucideIcons.eye,
    label: 'Themes'
  )),
  notifications(Destination(
    icon: LucideIcons.bell,
    label: 'Notifs'
  )),
  menu(Destination(
    icon: LucideIcons.menu,
    label: 'Menu',
  )),
  journal(Destination(
    icon: LucideIcons.book,
    label: 'Journal'
  )),
  bookmarks(Destination(
    icon: LucideIcons.bookmark,
    label: 'Bookmarks'
  )),
  settings(Destination(
    icon: LucideIcons.wrench,
    label: 'Settings'
  )),
  netiquette(Destination(
    icon: LucideIcons.scale,
    label: 'Netiquette'
  )),
  about(Destination(icon: LucideIcons.info, label: 'About')),
  logout(Destination(
    icon: LucideIcons.logOut,
    label: 'Log out'
  ));

  final Destination value;
  const AppDestination(this.value);
}

