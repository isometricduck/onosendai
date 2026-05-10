import 'package:flutter/widgets.dart';

class EinkShell extends StatefulWidget {
  const EinkShell({super.key});

  @override
  State<EinkShell> createState() => _EinkShellState();
}

class _EinkShellState extends State<_EinkShell> {
  var _selectedIndex = 0;

  void _selectDestination(int index) {
    final destination = _einkDestinations[index];

    if (destination.dialog != null) {
      showDialog<void>(
        context: context,
        builder: (context) => destination.dialog!(context, _selectDestination),
      );
      return;
    }

    if (destination.page == null) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme as ClassicTheme;
    final destination = _einkDestinations[_selectedIndex];

    final page = destination.page;

    return Scaffold(
      backgroundColor: theme.background,
      body: switch (page) {
        EinkFeedPage() => EinkFeedPage(
          source: page.source,
          destinationSheetBuilder: (context, hideOverlay) =>
              _EinkDestinationSheet(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  hideOverlay();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _selectDestination(index);
                  });
                },
              ),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _EinkDestinationSheet extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _EinkDestinationSheet({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme as ClassicTheme;
    final einkDestinations = _einkDestinations.indexed;

    return Material(
      color: theme.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            children: [
              for (final (index, destination) in einkDestinations) ...[
                Expanded(
                  child: _EinkDestinationButton(
                    destination: destination,
                    selected: index == selectedIndex,
                    onTap: () => onDestinationSelected(index),
                  ),
                ),
                if (index != einkDestinations.last.$1) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EinkDestinationButton extends StatelessWidget {
  final _AppDestination destination;
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
              Icon(destination.icon, color: contentColor, size: 28),
              const SizedBox(height: 6),
              Text(
                destination.label,
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

Widget _aboutDialog(
  BuildContext context,
  ValueChanged<int> onDestinationSelected,
) {
  return const OnosendaiAboutDialog();
}
