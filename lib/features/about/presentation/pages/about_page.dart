import 'package:flutter/material.dart';
import 'package:onosendai/features/theme/theme.dart';
import 'package:onosendai/features/about/presentation/widgets/about_content.dart';

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
            child: AboutContent(showInlineHeader: !isMobile),
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
