// ignore_for_file: implementation_imports

import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:onosendai/core/images/shader_effects.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

abstract class FourColorsTheme extends CyberTheme {

  Color get color0;
  Color get color1;
  Color get color2;
  Color get color3;

  @override
  IconData get icon;

  @override
  ImageShaderEffect get imageShaderEffect;

  @override
  TextStyle get mainFont;

  @override
  Color get actionIcon => color2;

  @override
  Color get cardBackground => color0;

  @override
  Color get cardBorder => color1;

  @override
  Color get dialogBackground => color0;

  @override
  Color get dialogBorder => color1;

  @override
  Color get divider => color1;

  @override
  Color get headingText => color3;

  @override
  Color get hintText => color1;

  @override
  Color get inputBackground => color0;

  @override
  Color get inputBorder => color1;

  @override
  Color get inputFocusBorder => color1;

  @override
  Color get metaText => color2;

  @override
  Color get navBackground => color0;

  @override
  Color get navBorder => color1;

  @override
  Color get navIndicator => color1;

  @override
  Color get navSelectedIcon => color3;

  @override
  Color get navSelectedLabel => color3;

  @override
  Color get navUnselectedIcon => color1;

  @override
  Color get navUnselectedLabel => color1;

  @override
  Color get notificationReadBorder => color1;

  @override
  Color get notificationReadIcon => color1;

  @override
  Color get notificationUnreadBorder => color1;

  @override
  Color get notificationUnreadIcon => color1;

  @override
  Color get overlayBackground => color0;

  @override
  Color get pageBackground => color0;

  @override
  Color get primaryButtonBackground => color0;

  @override
  Color get primaryButtonForeground => color1;

  @override
  Color get secondaryButtonBorder => color1;

  @override
  Color get snackbarBackground => color0;

  @override
  Color get snackbarText => color3;

  @override
  Color get switchActiveThumb => color1;

  @override
  Color get switchActiveTrack => color1;

  @override
  Color get switchInactiveThumb => color1;

  @override
  Color get switchInactiveTrack => color1;

}