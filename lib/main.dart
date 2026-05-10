import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/app_shell.dart';
import 'package:onosendai/core/prefs/shared_preferences_app_prefs.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/boot/presentation/boot_glitch.dart';
import 'package:onosendai/features/boot/presentation/riverpod/boot_animation_provider.dart';
import 'package:onosendai/features/login/presentation/pages/landing_page.dart';
import 'package:onosendai/features/settings/presentation/riverpod/font_scale_provider.dart';

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
  final initialFontScale = await _loadInitialFontScale(appPrefs);

  const app = MainApp();

  runApp(
    ProviderScope(
      overrides: [
        appPrefsProvider.overrideWithValue(appPrefs),
        initialAppThemeProvider.overrideWithValue(initialAppTheme),
        initialBootAnimationEnabledProvider.overrideWithValue(
          initialBootAnimationEnabled,
        ),
        initialFontScaleProvider.overrideWithValue(initialFontScale),
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

Future<double> _loadInitialFontScale(SharedPreferencesAppPrefs prefs) async {
  try {
    return await prefs.getDouble(fontScalePrefsKey) ?? 1.0;
  } catch (error, stackTrace) {
    debugPrint('Failed to load initial font scale: $error');
    debugPrintStack(stackTrace: stackTrace);
    return 1.0;
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
    final fontScale = ref.watch(fontScaleProvider);

    return AppThemeScope(
      theme: appTheme.theme,
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(fontScale),
          ),
          child: child!,
        ),
        home: const _AuthGate(),
      ),
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
    final theme = context.cyberTheme;

    return Scaffold(
      backgroundColor: theme.pageBackground,
      body: Center(
        child: SizedBox.square(
          dimension: 28,
          child: CircularProgressIndicator(
            color: theme.headingText,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
