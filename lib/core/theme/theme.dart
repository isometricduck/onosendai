import 'package:flutter/material.dart';
import 'package:onosendai/core/theme/dark_theme.dart';

extension AppColorsX on BuildContext {
  Theme get theme => DarkTheme();
}

abstract class Theme {
  Color get foreground;
  Color get background;
  Color get dimmed;
  Color get border;
  Color get code;
  Color get codeBg;
}
