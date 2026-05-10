import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/images/images.dart';
import 'package:onosendai/core/navigation/app_ui.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/login/presentation/login_dialog.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  bool _dialogOpen = false;
  bool _showFeed = false;

  Future<void> _showLoginDialog() async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    final loggedIn = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoginDialog(),
    ).whenComplete(() => _dialogOpen = false);

    if (!mounted) return;
    if (loggedIn ?? false) {
      setState(() => _showFeed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showFeed) return const AppUI();

    final theme = context.cyberTheme;

    return Scaffold(
      backgroundColor: theme.pageBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: const _LandingCopy(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: _HomeButton(label: 'Login', onPressed: _showLoginDialog),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LandingCopy extends StatelessWidget {
  const _LandingCopy();

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.cardBorder),
        color: theme.pageBackground,
      ),
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                text: TextSpan(
                  style: theme.mainFont.copyWith(fontSize: 18, height: 1.35),
                  children: [
                    TextSpan(
                      text: '''
ᑕ¥βєяรקค¢є

Social media de-imagined.
Use your words!

''',
                    ),
                    TextSpan(
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                      text:
                          "AI Videos Algorithm\nSuggestions Tracking\nCrypto Ads\n\n",
                    ),
                    TextSpan(
                      text: '''
A quiet corner of the internet where you can think, write, read and connect. Like how the internet was supposed to be.''',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _LandingImage(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LandingImage extends StatelessWidget {
  const _LandingImage();

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return Semantics(
      label: 'Caveman Hamlet',
      image: true,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 420),
        decoration: BoxDecoration(
          border: Border.all(color: theme.cardBorder, width: 1),
        ),
        clipBehavior: Clip.hardEdge,
        child: ShadedImage(
          imageProvider: const AssetImage('assets/images/caveman_hamlet.jpg'),
          fit: BoxFit.contain,
          effect: theme.imageShaderEffect,
          fallbackColor: theme.headingText,
          placeholderBuilder: (_) => const _LandingImagePlaceholder(),
          errorBuilder: (_) => const _LandingImageError(),
        ),
      ),
    );
  }
}

class _LandingImagePlaceholder extends StatelessWidget {
  const _LandingImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return SizedBox(
      height: 180,
      child: Center(
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: theme.actionIcon,
          ),
        ),
      ),
    );
  }
}

class _LandingImageError extends StatelessWidget {
  const _LandingImageError();

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return SizedBox(
      height: 120,
      child: Center(
        child: Text(
          '[image failed to load]',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: theme.hintText,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _HomeButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final enabled = onPressed != null;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: enabled ? theme.headingText : theme.hintText,
        disabledForegroundColor: theme.hintText,
        side: BorderSide(
          color: enabled ? theme.secondaryButtonBorder : theme.hintText,
        ),
        shape: const RoundedRectangleBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        textStyle: theme.mainFont.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Text(label),
    );
  }
}
