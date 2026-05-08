import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/features/theme/theme.dart';
import 'package:onosendai/features/boot/presentation/riverpod/boot_animation_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final bootAnimationEnabled = ref.watch(bootAnimationEnabledProvider);

    final body = ColoredBox(
      color: theme.background,
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
              children: [
                if (!isMobile) const _InlineHeader(),
                if (!isMobile) const SizedBox(height: 28),
                _SettingSwitchTile(
                  icon: LucideIcons.sparkles,
                  title: 'Boot animation',
                  value: bootAnimationEnabled,
                  onChanged: (value) => ref
                      .read(bootAnimationEnabledProvider.notifier)
                      .setEnabled(value),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!isMobile) {
      return Scaffold(backgroundColor: theme.background, body: body);
    }

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        foregroundColor: theme.foreground,
        surfaceTintColor: theme.background,
        title: Text(
          'SETTINGS',
          style: theme.mainFont.copyWith(
            color: theme.foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: body,
    );
  }
}

class _InlineHeader extends StatelessWidget {
  const _InlineHeader();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Icon(LucideIcons.wrench, color: theme.foreground),
        const SizedBox(width: 10),
        Text(
          'Settings',
          style: theme.mainFont.copyWith(
            color: theme.foreground,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SettingSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.border),
        color: theme.background,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: theme.foreground, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.mainFont.copyWith(
                      color: theme.foreground,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch(
              value: value,
              activeThumbColor: theme.foreground,
              activeTrackColor: theme.foreground.withValues(alpha: 0.32),
              inactiveThumbColor: theme.dimmed,
              inactiveTrackColor: theme.dimmed.withValues(alpha: 0.18),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
