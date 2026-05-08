import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/images/shader_effects.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/features/theme/themes/brutalist_theme.dart';
import 'package:onosendai/features/theme/themes/bubblegum_theme.dart';
import 'package:onosendai/features/theme/themes/c64_theme.dart';
import 'package:onosendai/features/theme/themes/crypt_theme.dart';
import 'package:onosendai/features/theme/themes/dark_theme.dart';
import 'package:onosendai/features/theme/themes/eink_theme.dart';
import 'package:onosendai/features/theme/themes/grid_theme.dart';
import 'package:onosendai/features/theme/themes/lcd_theme.dart';
import 'package:onosendai/features/theme/themes/light_theme.dart';
import 'package:onosendai/features/theme/themes/matrix_theme.dart';
import 'package:onosendai/features/theme/themes/poetry_theme.dart';
import 'package:onosendai/features/theme/themes/vt320_theme.dart';

enum AppThemeId {
  dark,
  light,
  lcd,
  c64,
  matrix,
  poetry,
  brutalist,
  grid,
  crypt,
  bubblegum,
  vt320,
  eink,
}

const appThemeIdPrefsKey = 'app_theme_id';

final initialAppThemeProvider = Provider<AppThemeId?>((ref) => null);

final appThemeProvider = NotifierProvider<AppThemeNotifier, AppThemeId>(
  AppThemeNotifier.new,
);

class AppThemeNotifier extends Notifier<AppThemeId> {
  @override
  AppThemeId build() {
    final initialTheme = ref.watch(initialAppThemeProvider);
    if (initialTheme != null) return initialTheme;

    unawaited(_loadTheme());
    return AppThemeId.dark;
  }

  Future<void> _loadTheme() async {
    final raw = await ref.read(appPrefsProvider).getString(appThemeIdPrefsKey);
    final themeId = AppThemeIdX.fromPrefsValue(raw);
    if (themeId != null) state = themeId;
  }

  Future<void> setTheme(AppThemeId themeId) async {
    state = themeId;
    await ref
        .read(appPrefsProvider)
        .setString(appThemeIdPrefsKey, themeId.prefsValue);
  }
}

extension AppThemeIdX on AppThemeId {
  static AppThemeId? fromPrefsValue(String? value) {
    if (value == null) return null;

    for (final themeId in AppThemeId.values) {
      if (themeId.prefsValue == value) return themeId;
    }

    return null;
  }

  String get prefsValue => name;

  String get label {
    return switch (this) {
      AppThemeId.dark => 'Dark',
      AppThemeId.light => 'Light',
      AppThemeId.lcd => 'LCD',
      AppThemeId.c64 => 'C64',
      AppThemeId.vt320 => 'VT320',
      AppThemeId.matrix => 'Matrix',
      AppThemeId.poetry => 'Poetry',
      AppThemeId.brutalist => 'Brutalist',
      AppThemeId.grid => 'Grid',
      AppThemeId.crypt => 'Crypt',
      AppThemeId.bubblegum => 'Bubblegum',
      AppThemeId.eink => "E-Ink",
    };
  }

  Theme get theme {
    return switch (this) {
      AppThemeId.dark => DarkTheme(),
      AppThemeId.light => LightTheme(),
      AppThemeId.lcd => LcdTheme(),
      AppThemeId.c64 => C64Theme(),
      AppThemeId.matrix => MatrixTheme(),
      AppThemeId.poetry => PoetryTheme(),
      AppThemeId.brutalist => BrutalistTheme(),
      AppThemeId.grid => GridTheme(),
      AppThemeId.crypt => CryptTheme(),
      AppThemeId.bubblegum => BubblegumTheme(),
      AppThemeId.vt320 => Vt320Theme(),
      AppThemeId.eink => EinkTheme(),
    };
  }
}

class AppThemeScope extends InheritedWidget {
  final Theme theme;

  const AppThemeScope({super.key, required this.theme, required super.child});

  static Theme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeScope>()?.theme ??
        DarkTheme();
  }

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) {
    return theme.runtimeType != oldWidget.theme.runtimeType;
  }
}

extension AppColorsX on BuildContext {
  Theme get theme => AppThemeScope.of(this);
}

abstract class Theme {
  bool get isDark; // True if background is darker than foreground
  IconData get icon;
  Color get foreground;
  Color get background;
  Color get dimmed;
  Color get border;
  TextStyle get font;

  TextStyle get mainFont => font.copyWith(color: foreground);

  ImageShaderEffect get imageShaderEffect => DitherEffect(
    foreground: isDark ? foreground : background,
    background: isDark ? background : foreground,
  );
}
