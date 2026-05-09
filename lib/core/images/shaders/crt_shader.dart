part of '../shader_effects.dart';

class CrtEffect extends ImageShaderEffect {
  final double saturation;
  final double scanline;
  final double curvature;
  final double vignette;

  const CrtEffect({
    this.saturation = 0.03,
    this.scanline = 2.5,
    this.curvature = 0.12,
    this.vignette = 0.40,
  });

  @override
  String get assetPath => 'assets/shaders/crt.glsl';

  @override
  bool get isAnimated => false;

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
