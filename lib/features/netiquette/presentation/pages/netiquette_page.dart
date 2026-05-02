import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';

class NetiquettePage extends StatelessWidget {
  const NetiquettePage({super.key});

  static const _rules = <String>[
    'Be excellent to each other. Be kind and respectful. Avoid personal attacks.',
    'No calls to violence (including self-harm), hate speech, or harassment.',
    'No sharing illegal content or promoting illegal activities.',
    'No hacking*, spamming, bots, or AI agents.',
    'Tag your NSFW content as such.',
    'Flag content that goes against Cyberspace netiquette (not just because you disagree with it).',
    'Share thoughts and creations as you see fit.',
    'Show grace and dignity. Respect differing opinions, ideas, and identities.',
    'Let the vibes be cosy and welcoming.',
  ];

  static const _footnote =
      '* Whitehats are invited to report vulnerabilities and earn the hacker badge and some special access. Send a C-Mail to @genghis_khan';

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    final body = ColoredBox(
      color: theme.background,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
              children: [
                if (!isMobile) const _InlineHeader(),
                if (!isMobile) const SizedBox(height: 24),
                Text(
                  'CYBERSPACE NETIQUETTE v1.0',
                  style: theme.mainFont.copyWith(
                    color: theme.foreground,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                for (var index = 0; index < _rules.length; index++) ...[
                  _RuleItem(number: index + 1, text: _rules[index]),
                  const SizedBox(height: 14),
                ],
                const SizedBox(height: 10),
                Text(
                  _footnote,
                  style: theme.mainFont.copyWith(
                    color: theme.dimmed,
                    height: 1.45,
                  ),
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
          'NETIQUETTE',
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
        Icon(LucideIcons.badgeCheck, color: theme.foreground),
        const SizedBox(width: 10),
        Text(
          'Netiquette',
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

class _RuleItem extends StatelessWidget {
  final int number;
  final String text;

  const _RuleItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: Text(
            '$number.',
            textAlign: TextAlign.right,
            style: theme.mainFont.copyWith(
              color: theme.foreground,
              fontWeight: FontWeight.w700,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.mainFont.copyWith(
              color: theme.foreground,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
