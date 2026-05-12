import 'package:flutter/material.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/about/presentation/widgets/about_content.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    final body = ColoredBox(
      color: theme.pageBackground,
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
      return Scaffold(backgroundColor: theme.pageBackground, body: body);
    }

    return Scaffold(
      backgroundColor: theme.pageBackground,
      appBar: AppBar(
        backgroundColor: theme.pageBackground,
        foregroundColor: theme.headingText,
        surfaceTintColor: theme.pageBackground,
        title: Text(
          'ABOUT',
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
