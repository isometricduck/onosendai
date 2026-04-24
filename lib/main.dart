import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/feed/presentation/pages/feed_page.dart';
import 'package:onosendai/features/login/login_dialog.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: _HomePage());
  }
}

class _HomePage extends ConsumerStatefulWidget {
  const _HomePage();

  @override
  ConsumerState<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<_HomePage> {
  bool _dialogOpen = false;

  void _showLoginDialog() {
    if (_dialogOpen) return;
    _dialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoginDialog(),
    ).whenComplete(() => _dialogOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthTokens?>>(authTokensProvider, (previous, next) {
      final wasLoggedOut = previous?.valueOrNull == null;
      final isLoggedIn = next.valueOrNull != null;
      if (wasLoggedOut && isLoggedIn && _dialogOpen) {
        Navigator.of(context).pop();
      }
    });

    final tokensAsync = ref.watch(authTokensProvider);
    final blank = Scaffold(body: Container(color: context.theme.background));

    return tokensAsync.when(
      loading: () => blank,
      error: (_, _) => blank,
      data: (tokens) {
        if (tokens != null) return const FeedPage();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showLoginDialog();
        });
        return blank;
      },
    );
  }
}
