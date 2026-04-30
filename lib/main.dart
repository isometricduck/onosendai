import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/app_shell.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/login/presentation/login_dialog.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint(details.exceptionAsString());
    if (details.stack != null) debugPrintStack(stackTrace: details.stack);
  };

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider);

    return AppThemeScope(
      theme: appTheme.theme,
      child: const MaterialApp(home: _HomePage()),
    );
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
    final tokensAsync = ref.watch(authTokensProvider);
    final blank = Scaffold(body: Container(color: context.theme.background));

    return tokensAsync.when(
      loading: () => blank,
      error: (_, _) => blank,
      data: (tokens) {
        if (tokens != null) return const AppShell();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showLoginDialog();
        });
        return blank;
      },
    );
  }
}
