part of 'package:onosendai/core/images/shader_effects.dart';

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