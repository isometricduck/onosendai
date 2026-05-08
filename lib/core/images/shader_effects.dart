import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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

class DitherEffect extends ImageShaderEffect {
  final double pixelSize;
  final double ditherAmount;
  final double bitDepth;
  final double contrast;
  final Color foreground;
  final Color background;

  const DitherEffect({
    this.pixelSize = 2,
    this.ditherAmount = 0.85,
    this.bitDepth = 1,
    this.contrast = 1.2,
    this.foreground = const Color(0xFFEBDBB2),
    this.background = const Color(0xFF1D2021),
  });

  @override
  String get assetPath => 'assets/shaders/dither.glsl';

  @override
  void applyUniforms(
    ui.FragmentShader shader,
    ui.Image image,
    Size size,
    double timeSeconds,
  ) {
    shader
      ..setImageSampler(0, image)
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, pixelSize)
      ..setFloat(3, ditherAmount)
      ..setFloat(4, bitDepth)
      ..setFloat(5, contrast)
      ..setFloat(6, foreground.r)
      ..setFloat(7, foreground.g)
      ..setFloat(8, foreground.b)
      ..setFloat(9, background.r)
      ..setFloat(10, background.g)
      ..setFloat(11, background.b);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DitherEffect &&
        other.pixelSize == pixelSize &&
        other.ditherAmount == ditherAmount &&
        other.bitDepth == bitDepth &&
        other.contrast == contrast &&
        other.foreground == foreground &&
        other.background == background;
  }

  @override
  int get hashCode => Object.hash(
    pixelSize,
    ditherAmount,
    bitDepth,
    contrast,
    foreground,
    background,
  );
}

class ScanlinesEffect extends ImageShaderEffect {
  final Color foreground;
  final Color background;
  final double lineSpacing;
  final double lineIntensity;

  const ScanlinesEffect({
    required this.foreground,
    required this.background,
    this.lineSpacing = 3,
    this.lineIntensity = 0.4,
  });

  @override
  String get assetPath => 'assets/shaders/scanlines.glsl';

  @override
  void applyUniforms(
    ui.FragmentShader shader,
    ui.Image image,
    Size size,
    double timeSeconds,
  ) {
    shader
      ..setImageSampler(0, image)
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, lineSpacing)
      ..setFloat(3, lineIntensity)
      ..setFloat(4, foreground.r)
      ..setFloat(5, foreground.g)
      ..setFloat(6, foreground.b)
      ..setFloat(7, background.r)
      ..setFloat(8, background.g)
      ..setFloat(9, background.b);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanlinesEffect &&
        other.foreground == foreground &&
        other.background == background &&
        other.lineSpacing == lineSpacing &&
        other.lineIntensity == lineIntensity;
  }

  @override
  int get hashCode =>
      Object.hash(foreground, background, lineSpacing, lineIntensity);
}

class CrtEffect extends ImageShaderEffect {
  final double saturation;
  final double scanline;
  final double curvature;
  final double vignette;

  const CrtEffect({
    this.saturation = 0.15,
    this.scanline = 0.18,
    this.curvature = 0.08,
    this.vignette = 0.40,
  });

  @override
  String get assetPath => 'assets/shaders/crt.glsl';

  @override
  bool get isAnimated => true;

  @override
  void applyUniforms(
    ui.FragmentShader shader,
    ui.Image image,
    Size size,
    double timeSeconds,
  ) {
    shader
      ..setImageSampler(0, image)
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, timeSeconds)
      ..setFloat(3, saturation)
      ..setFloat(4, scanline)
      ..setFloat(5, curvature)
      ..setFloat(6, vignette);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CrtEffect &&
        other.saturation == saturation &&
        other.scanline == scanline &&
        other.curvature == curvature &&
        other.vignette == vignette;
  }

  @override
  int get hashCode => Object.hash(saturation, scanline, curvature, vignette);
}
