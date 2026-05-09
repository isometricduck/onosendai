import 'dart:ui' as ui;

import 'package:flutter/material.dart';

part 'shaders/dither_shader.dart';
part 'shaders/crt_shader.dart';
part 'shaders/scanlines_shader.dart';
part 'shaders/cga0_shader.dart';
part 'shaders/vhs_shader.dart';
part 'shaders/neon_shader.dart';

@immutable
abstract class ImageShaderEffect {
  const ImageShaderEffect();

  String get assetPath;

  bool get isAnimated => false;

  void applyUniforms(
    ui.FragmentShader shader,
    ui.Image image,
    Size size,
    double timeSeconds,
  );
}
