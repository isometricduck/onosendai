import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/desktop_shell.dart';
import 'package:onosendai/core/navigation/eink_shell.dart';
import 'package:onosendai/core/navigation/mobile_shell.dart';

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
      return LandscapeShell(railWidth: 100, extended: false);
    }

    return LandscapeShell(railWidth: 220, extended: true);
  }
}