part of '../shader_effects.dart';

class NeonEffect extends ImageShaderEffect {
  final double dither;
  final double blend;
  final double pulseStrength;
  final double pulseSpeed;
  final double lightBoost;

  const NeonEffect({
    this.dither = 0.35,
    this.blend = 1.0,
    this.pulseStrength = 0.6,
    this.pulseSpeed = 0.2,
    this.lightBoost = 0.9,
  });

  @override
  String get assetPath => 'assets/shaders/neon.glsl';

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
      ..setFloat(3, dither)
      ..setFloat(4, blend)
      ..setFloat(5, pulseStrength)
      ..setFloat(6, pulseSpeed)
      ..setFloat(7, lightBoost);      
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NeonEffect 
      && other.dither == dither 
      && other.blend == blend
      && other.pulseStrength == pulseStrength
      && other.pulseSpeed == pulseSpeed
      && other.lightBoost == lightBoost;
  }

  @override
  int get hashCode => Object.hash(dither, blend, pulseStrength, pulseSpeed, lightBoost);
}
