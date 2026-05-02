import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    final body = ColoredBox(
      color: theme.background,
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
              children: [
                if (!isMobile) const _InlineHeader(),
                if (!isMobile) const SizedBox(height: 28),
                Center(
                  child: Image(
                    image: AssetImage('assets/images/onosendai_icon.png'),
                    width: 200,
                    color: theme.foreground,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Ono-Sendai',
                  textAlign: TextAlign.center,
                  style: theme.mainFont.copyWith(
                    color: theme.foreground,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'An Android client for the ᑕ¥βєяรקค¢є network',
                  textAlign: TextAlign.center,
                  style: theme.mainFont.copyWith(
                    color: theme.foreground,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 32),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final info = snapshot.data;
                    final version = info == null
                        ? 'Version unavailable'
                        : 'Version ${info.version}';

                    return Text(
                      version,
                      textAlign: TextAlign.center,
                      style: theme.mainFont.copyWith(
                        color: theme.foreground,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'Send bug reports and suggestions to @elmagochan',
                  textAlign: TextAlign.center,
                  style: theme.mainFont.copyWith(
                    color: theme.foreground,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
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
          'ABOUT',
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
        Icon(LucideIcons.info, color: theme.foreground),
        const SizedBox(width: 10),
        Text(
          'About',
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
