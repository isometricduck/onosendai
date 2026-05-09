part of '../shader_effects.dart';

class Cga0Effect extends ImageShaderEffect {
  
  const Cga0Effect();

  @override
  String get assetPath => 'assets/shaders/cga0.glsl';

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
      ..setFloat(1, size.height);
  }
}
