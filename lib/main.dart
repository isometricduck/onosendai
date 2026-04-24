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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authTokensProvider) == null) {
        _showLoginDialog();
      }
    });
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoginDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authTokensProvider, (previous, next) {
      if (previous == null && next != null) {
        Navigator.of(context).pop();
      }
    });

    final isLoggedIn = ref.watch(authTokensProvider) != null;

    if (isLoggedIn) {
      return const FeedPage();
    }

    return Scaffold(
      body: Container(color: context.theme.background),
    );
  }
}
