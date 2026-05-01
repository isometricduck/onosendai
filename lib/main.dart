import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/app_shell.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/login/presentation/pages/landing_page.dart';

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
      child: const MaterialApp(home: _AuthGate()),
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(authTokensProvider);

    return tokens.when(
      loading: () => const _LoadingPage(),
      error: (_, _) => const LandingPage(),
      data: (tokens) => tokens == null ? const LandingPage() : const AppShell(),
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.background,
      body: Center(
        child: SizedBox.square(
          dimension: 28,
          child: CircularProgressIndicator(
            color: theme.foreground,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
