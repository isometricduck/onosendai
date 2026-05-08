import 'package:flutter/material.dart';
import 'package:onosendai/core/images/shader_effects.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';


abstract class ClassicTheme extends CyberTheme {

  bool get isDark; // True if background is darker than foreground
  Color get foreground;
  Color get background;
  Color get dimmed;
  Color get border;
  TextStyle get font;

  @override
  IconData get icon;

  @override
  TextStyle get mainFont => font.copyWith(color: foreground);

  @override
  ImageShaderEffect get imageShaderEffect => DitherEffect(
    foreground: isDark ? foreground : background,
    background: isDark ? background : foreground,
  );
  
    // Text
  @override
  Color get headingText => foreground;
  @override
  Color get metaText => dimmed;
  @override
  Color get hintText => dimmed;

  // Surfaces
  @override
  Color get pageBackground => background;
  @override
  Color get cardBackground => background;
  @override
  Color get dialogBackground => background;
  @override
  Color get inputBackground => background;
  @override
  Color get navBackground => background;
  @override
  Color get overlayBackground => background;

  // Strokes
  @override
  Color get cardBorder => border;
  @override
  Color get divider => border;
  @override
  Color get inputBorder => border;
  @override
  Color get inputFocusBorder => foreground;
  @override
  Color get dialogBorder => border;
  @override
  Color get navBorder => border;

  // Interactive
  @override
  Color get actionIcon => dimmed;
  @override
  Color get navSelectedIcon => foreground;
  @override
  Color get navUnselectedIcon => dimmed;
  @override
  Color get navIndicator => dimmed;
  @override
  Color get navSelectedLabel => foreground;
  @override
  Color get navUnselectedLabel => dimmed;
  @override
  Color get primaryButtonBackground => foreground;
  @override
  Color get primaryButtonForeground => background;
  @override
  Color get secondaryButtonBorder => dimmed;
  @override
  Color get switchActiveThumb => foreground;
  @override
  Color get switchActiveTrack => foreground;
  @override
  Color get switchInactiveThumb => dimmed;
  @override
  Color get switchInactiveTrack => dimmed;
  @override
  Color get snackbarBackground => foreground;
  @override
  Color get snackbarText => background;
  @override
  Color get notificationUnreadBorder => foreground;
  @override
  Color get notificationReadBorder => border;
  @override
  Color get notificationUnreadIcon => foreground;
  @override
  Color get notificationReadIcon => dimmed;
}