import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Colors;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/images/shader_effects.dart';
import 'package:onosendai/features/theme/four_colors_theme.dart';

class CGA0Theme extends FourColorsTheme {

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
  ImageShaderEffect get imageShaderEffect => const CrtEffect();
  
  @override
  TextStyle get mainFont => TextStyle(
    fontFamily: 'VT323',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: color3,
  );
}
