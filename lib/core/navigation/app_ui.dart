import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/desktop_shell.dart';
import 'package:onosendai/core/navigation/eink_shell.dart';
import 'package:onosendai/core/navigation/mobile_shell.dart';
import 'package:onosendai/core/navigation/tablet_shell.dart';

class AppUI extends ConsumerWidget {
  const AppUI({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (const bool.fromEnvironment('EINK')) {
      return const EinkShell();
    }
    
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return MobileShell();
    }

    if (width < 1280) {
      return TabletShell();
    }

    return DesktopShell();
  }
}

/*
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
*/