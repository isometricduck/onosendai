import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/theme/dark_theme.dart';
import 'package:onosendai/core/theme/vt320_theme.dart';

enum AppThemeId { dark, vt320 }

final appThemeProvider = StateProvider<AppThemeId>((ref) => AppThemeId.dark);

extension AppThemeIdX on AppThemeId {
  String get label {
    return switch (this) {
      AppThemeId.dark => 'dark',
      AppThemeId.vt320 => 'VT320',
    };
  }

  Theme get theme {
    return switch (this) {
      AppThemeId.dark => DarkTheme(),
      AppThemeId.vt320 => Vt320Theme(),
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
  Color get foreground;
  Color get background;
  Color get dimmed;
  Color get border;
  TextStyle get mainFont;
  TextStyle get codeFont;
}
