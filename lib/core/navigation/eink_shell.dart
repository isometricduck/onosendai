import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/core/navigation/shell_effect.dart';
import 'package:onosendai/core/providers/nav_provider.dart';
import 'package:onosendai/features/about/presentation/widgets/about_dialog.dart';
import 'package:onosendai/features/feed/presentation/pages/eink_feed_page.dart';
import 'package:onosendai/features/login/presentation/logout_dialog.dart';
import 'package:onosendai/features/theme/classic_theme.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

const einkDestinations = <AppDestination>[
  AppDestination.feed,
  AppDestination.bookmarks,
  AppDestination.about,
  AppDestination.logout,
];

class EinkShell extends ConsumerWidget {
  const EinkShell({super.key});

  void _selectDestination(WidgetRef ref, AppDestination destination) {
    final nav = ref.read(navNotifierProvider.notifier);

    switch (destination) {
      case AppDestination.about:
        nav.showEffect(ShellEffect.about);
      case AppDestination.logout:
        nav.showEffect(ShellEffect.logout);
        return;
      default:
        nav.goTo(destination);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.cyberTheme as ClassicTheme;
    final navState = ref.watch(navNotifierProvider);

    ref.listen(navNotifierProvider, (previous, next) {
      final effect = next.pendingEffect;
      if (effect == null) return;

      switch (effect) {
        case ShellEffect.themes:
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
      backgroundColor: theme.background,
      body: 
        EinkFeedPage(
          // This is horrible
          source: navState.destination == AppDestination.feed ? EinkFeedSource.feed : EinkFeedSource.bookmarks,
          destinationSheetBuilder: (context, hideOverlay) =>
              _EinkDestinationSheet(
                selectedDestination: navState.destination,
                onDestinationSelected: (destination) {
                  hideOverlay();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _selectDestination(ref, destination);
                  });
                },
              ),
        ),
    );
  }
}

class _EinkDestinationSheet extends StatelessWidget {
  final AppDestination selectedDestination;
  final ValueChanged<AppDestination> onDestinationSelected;

  const _EinkDestinationSheet({
    required this.selectedDestination,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme as ClassicTheme;

    return Material(
      color: theme.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            children: [
              for (final destination in einkDestinations) ...[
                Expanded(
                  child: _EinkDestinationButton(
                    destination: destination,
                    selected: destination == selectedDestination,
                    onTap: () => onDestinationSelected(destination),
                  ),
                ),
                //if (index != einkDestinations.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EinkDestinationButton extends StatelessWidget {
  final AppDestination destination;
  final bool selected;
  final VoidCallback onTap;

  const _EinkDestinationButton({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme as ClassicTheme;
    final contentColor = selected ? theme.background : theme.foreground;

    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? theme.foreground : theme.background,
          border: Border.all(color: theme.foreground, width: 1),
        ),
        child: SizedBox(
          height: 72,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(destination.value.icon, color: contentColor, size: 28),
              const SizedBox(height: 6),
              Text(
                destination.value.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.mainFont.copyWith(
                  color: contentColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
