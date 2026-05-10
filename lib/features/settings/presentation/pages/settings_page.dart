import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/boot/presentation/riverpod/boot_animation_provider.dart';
import 'package:onosendai/features/settings/presentation/riverpod/font_scale_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final bootAnimationEnabled = ref.watch(bootAnimationEnabledProvider);
    final fontScale = ref.watch(fontScaleProvider);

    final body = ColoredBox(
      color: theme.pageBackground,
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
                const SizedBox(height: 8),
                _SettingSliderTile(
                  icon: LucideIcons.type,
                  title: 'Text size',
                  value: fontScale,
                  onChanged: (value) =>
                      ref.read(fontScaleProvider.notifier).setScale(value),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!isMobile) {
      return Scaffold(backgroundColor: theme.pageBackground, body: body);
    }

    return Scaffold(
      backgroundColor: theme.pageBackground,
      appBar: AppBar(
        backgroundColor: theme.pageBackground,
        foregroundColor: theme.headingText,
        surfaceTintColor: theme.pageBackground,
        title: Text(
          'SETTINGS',
          style: theme.mainFont.copyWith(
            color: theme.headingText,
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
        Icon(LucideIcons.wrench, color: theme.headingText),
        const SizedBox(width: 10),
        Text(
          'Settings',
          style: theme.mainFont.copyWith(
            color: theme.headingText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SettingSliderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  const _SettingSliderTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  String get _label => '${(value * 100).round()}%';

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.cardBorder),
        color: theme.cardBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: theme.headingText, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: theme.mainFont.copyWith(
                      color: theme.headingText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  _label,
                  style: theme.mainFont.copyWith(
                    color: theme.metaText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: theme.actionIcon,
                inactiveTrackColor: theme.cardBorder,
                thumbColor: theme.actionIcon,
                overlayColor: theme.actionIcon.withValues(alpha: 0.12),
              ),
              child: Slider(
                value: value,
                min: 0.8,
                max: 1.6,
                divisions: 4,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
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
        border: Border.all(color: theme.cardBorder),
        color: theme.cardBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: theme.headingText, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.mainFont.copyWith(
                      color: theme.headingText,
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
              activeThumbColor: theme.switchActiveThumb,
              activeTrackColor: theme.switchActiveTrack.withValues(alpha: 0.32),
              inactiveThumbColor: theme.switchInactiveThumb,
              inactiveTrackColor: theme.switchInactiveTrack.withValues(alpha: 0.18),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
