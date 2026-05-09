import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/images/shader_effects.dart';
import 'package:onosendai/features/theme/four_colors_theme.dart';

class BwTheme extends FourColorsTheme {

  @override
  Color color0 = Color.fromRGBO(10, 10, 13, 1);
  @override
  Color color1 = Color.fromRGBO(244, 244, 248, 1);
  @override
  Color color2 = Color.fromRGBO(244, 244, 248, 1);
  @override
  Color color3 = Color.fromRGBO(138, 138, 142, 1);
  
  @override
  IconData get icon => LucideIcons.tv2;
  
  @override
  ImageShaderEffect get imageShaderEffect => const CrtEffect();
  
  @override
  TextStyle get mainFont => TextStyle(
    fontFamily: 'VT323',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: color3,
  );

  // secondary: JetBrains
}