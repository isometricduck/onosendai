import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/app_shell.dart';
import 'package:onosendai/core/prefs/shared_preferences_app_prefs.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/boot/presentation/boot_glitch.dart';
import 'package:onosendai/features/boot/presentation/riverpod/boot_animation_provider.dart';
import 'package:onosendai/features/login/presentation/pages/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint(details.exceptionAsString());
    if (details.stack != null) debugPrintStack(stackTrace: details.stack);
  };

  const isEink = bool.fromEnvironment('EINK');
  final appPrefs = SharedPreferencesAppPrefs();
  final initialAppTheme = isEink ? AppThemeId.eink : await _loadInitialAppTheme(appPrefs);
  final initialBootAnimationEnabled = isEink ? false : await _loadInitialBootAnimationEnabled(
    appPrefs,
  );

  const app = MainApp();

  runApp(
    ProviderScope(
      overrides: [
        appPrefsProvider.overrideWithValue(appPrefs),
        initialAppThemeProvider.overrideWithValue(initialAppTheme),
        initialBootAnimationEnabledProvider.overrideWithValue(
          initialBootAnimationEnabled,
        ),
      ],
      child: initialBootAnimationEnabled
          ? const GlitchBootAnimation(
              duration: Duration(milliseconds: 1500),
              child: app,
            )
          : app,
    ),
  );
}

Future<AppThemeId> _loadInitialAppTheme(SharedPreferencesAppPrefs prefs) async {
  try {
    final raw = await prefs.getString(appThemeIdPrefsKey);
    return AppThemeIdX.fromPrefsValue(raw) ?? AppThemeId.dark;
  } catch (error, stackTrace) {
    debugPrint('Failed to load initial app theme: $error');
    debugPrintStack(stackTrace: stackTrace);
    return AppThemeId.dark;
  }
}

Future<bool> _loadInitialBootAnimationEnabled(
  SharedPreferencesAppPrefs prefs,
) async {
  try {
    return await prefs.getBool(bootAnimationEnabledPrefsKey) ?? true;
  } catch (error, stackTrace) {
    debugPrint('Failed to load boot animation setting: $error');
    debugPrintStack(stackTrace: stackTrace);
    return true;
  }
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
