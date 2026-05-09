import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show FontWeight, IconData;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/images/shader_effects.dart';
import 'package:onosendai/features/theme/four_colors_theme.dart';

class NeonTheme extends FourColorsTheme {
  @override
  Color color0 = const Color(0xFF070510);
  @override
  Color color1 = const Color(0xFFFF2BD6);
  @override
  Color color2 = const Color(0xFF3DF0FF);
  @override
  Color color3 = const Color(0xFFC8FF3D);

  @override
  IconData get icon => LucideIcons.zap;

  @override
  ImageShaderEffect get imageShaderEffect => const NeonEffect();

  @override
  TextStyle get mainFont => TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color3,
  );

  // secondary: JetBrains
}
