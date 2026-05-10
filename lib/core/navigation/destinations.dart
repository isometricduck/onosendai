import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';

/* typedef AppDestinationSheetBuilder =
    Widget Function(
      BuildContext context,
      ValueChanged<int> onDestinationSelected,
    );
typedef AppDestinationDialogBuilder =
    Widget Function(
      BuildContext context,
      ValueChanged<int> onDestinationSelected,
    ); */

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

