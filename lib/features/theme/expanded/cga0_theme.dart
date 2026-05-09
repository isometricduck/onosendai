import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Colors;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/images/shader_effects.dart';
import 'package:onosendai/features/theme/four_colors_theme.dart';

class Cga0Theme extends FourColorsTheme {

  @override
  Color color0 = Colors.black;
  @override
  Color color1 = Color.fromRGBO(55, 255, 55, 1);
  @override
  Color color2 = Color.fromRGBO(255, 55, 55, 1);
  @override
  Color color3 = Color.fromRGBO(255, 255, 55, 1);
  
  @override
  IconData get icon => LucideIcons.appWindow;
  
  @override
  ImageShaderEffect get imageShaderEffect => const Cga0Effect();
  
  @override
  TextStyle get mainFont => TextStyle(
    fontFamily: 'DotGothic16',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: color3,
  );

  // secondary: VT323
}
