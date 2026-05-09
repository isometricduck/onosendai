part of '../shader_effects.dart';

class VhsEffect extends ImageShaderEffect {

  final double noise;
  final double chroma;
  final double scanlines;
  final double jitter;
  final double rolllines;
  final double vignette;

  const VhsEffect({
    this.noise = 0.6,
    this.chroma = 0.01,
    this.scanlines = 0.25,
    this.jitter = 0.025,
    this.rolllines = 0.2,
    this.vignette = 0.3,
  });

  @override
  String get assetPath => 'assets/shaders/vhs.glsl';

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
      ..setFloat(3, noise)
      ..setFloat(4, chroma)
      ..setFloat(5, scanlines)
      ..setFloat(6, jitter)
      ..setFloat(7, rolllines)
      ..setFloat(8, vignette);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VhsEffect &&
        other.noise == noise &&
        other.chroma == chroma &&
        other.scanlines == scanlines &&
        other.jitter == jitter &&
        other.rolllines == rolllines &&
        other.vignette == vignette;
  }

  @override
  int get hashCode => Object.hash(noise, chroma, scanlines, jitter, rolllines, vignette);
}
