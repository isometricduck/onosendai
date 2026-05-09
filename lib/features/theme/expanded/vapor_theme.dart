import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/images/shader_effects.dart';
import 'package:onosendai/features/theme/four_colors_theme.dart';

class VaporTheme extends FourColorsTheme {

  @override
  Color color0 = Color.fromRGBO(0x2A, 0x18, 0x40, 1);
  @override
  Color color1 = Color.fromRGBO(0xC9, 0xB0, 0xFF, 1);
  @override
  Color color2 = Color.fromRGBO(0xFF, 0xB3, 0xD9, 1);
  @override
  Color color3 = Color.fromRGBO(0xA3, 0xF0, 0xD0, 1);
  
  @override
  IconData get icon => LucideIcons.videotape;
  
  @override
  ImageShaderEffect get imageShaderEffect => const VhsEffect();
  
  @override
  TextStyle get mainFont => TextStyle(
    fontFamily: 'VCROSDMono',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color3,
  );

  // secondary: Space Mono
}