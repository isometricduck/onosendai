part of '../shader_effects.dart';

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
