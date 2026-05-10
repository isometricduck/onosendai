import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/images/shader_effects.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';
import 'package:onosendai/features/theme/classic/brutalist_theme.dart';
import 'package:onosendai/features/theme/classic/bubblegum_theme.dart';
import 'package:onosendai/features/theme/classic/c64_theme.dart';
import 'package:onosendai/features/theme/classic/crypt_theme.dart';
import 'package:onosendai/features/theme/classic/dark_theme.dart';
import 'package:onosendai/features/theme/classic/eink_theme.dart';
import 'package:onosendai/features/theme/classic/grid_theme.dart';
import 'package:onosendai/features/theme/classic/lcd_theme.dart';
import 'package:onosendai/features/theme/classic/light_theme.dart';
import 'package:onosendai/features/theme/classic/matrix_theme.dart';
import 'package:onosendai/features/theme/classic/poetry_theme.dart';
import 'package:onosendai/features/theme/classic/vt320_theme.dart';
import 'package:onosendai/features/theme/expanded/bw_theme.dart';
import 'package:onosendai/features/theme/expanded/cga0_theme.dart';
import 'package:onosendai/features/theme/expanded/neon_theme.dart';
import 'package:onosendai/features/theme/expanded/vapor_theme.dart';

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
  cga0,
  bw,
  vapor,
  neon,
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
      AppThemeId.eink => 'E-Ink',
      AppThemeId.cga0 => 'CGA 0',
      AppThemeId.bw => 'B & W',
      AppThemeId.vapor => 'Vaporwave',
      AppThemeId.neon => 'Neon',
    };
  }

  CyberTheme get theme {
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
      AppThemeId.cga0 => Cga0Theme(),
      AppThemeId.bw => BwTheme(),
      AppThemeId.vapor => VaporTheme(),
      AppThemeId.neon => NeonTheme(),
    };
  }
}

class AppThemeScope extends InheritedWidget {
  final CyberTheme theme;

  const AppThemeScope({super.key, required this.theme, required super.child});

  static CyberTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeScope>()?.theme ??
        DarkTheme();
  }

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) {
    return theme.runtimeType != oldWidget.theme.runtimeType;
  }
}

extension AppColorsX on BuildContext {
  CyberTheme get cyberTheme => AppThemeScope.of(this);
}

abstract class CyberTheme {
  IconData get icon;

  TextStyle get mainFont;

  ImageShaderEffect get imageShaderEffect;

  // Text
  Color get headingText;
  Color get metaText;
  Color get hintText;

  // Surfaces
  Color get pageBackground;
  Color get cardBackground;
  Color get dialogBackground;
  Color get inputBackground;
  Color get navBackground;
  Color get overlayBackground;

  // Strokes
  Color get cardBorder;
  Color get divider;
  Color get inputBorder;
  Color get inputFocusBorder;
  Color get dialogBorder;
  Color get navBorder;

  // Interactive
  Color get actionIcon;
  Color get navSelectedIcon;
  Color get navUnselectedIcon;
  Color get navIndicator;
  Color get navSelectedLabel;
  Color get navUnselectedLabel;
  Color get primaryButtonBackground;
  Color get primaryButtonForeground;
  Color get secondaryButtonBorder;
  Color get switchActiveThumb;
  Color get switchActiveTrack;
  Color get switchInactiveThumb;
  Color get switchInactiveTrack;
  Color get snackbarBackground;
  Color get snackbarText;
  Color get notificationUnreadBorder;
  Color get notificationReadBorder;
  Color get notificationUnreadIcon;
  Color get notificationReadIcon;
}
