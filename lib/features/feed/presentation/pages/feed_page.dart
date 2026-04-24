import 'package:flutter/material.dart';
import 'package:onosendai/core/theme/theme.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.background,
      body: Center(
        child: Text(
          'FEED',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: context.theme.foreground,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}
