#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float uSaturation;
uniform float uScanline;
uniform float uCurvature;
uniform float uVignette;
uniform sampler2D uTexture;

out vec4 fragColor;

vec2 crtWarp(vec2 uv, float k) {
    uv = uv * 2.0 - 1.0;
    uv *= 1.0 + k * dot(uv, uv);
    return uv * 0.5 + 0.5;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uSize;

    vec2 warped = crtWarp(uv, uCurvature);

    if (warped.x < 0.0 || warped.x > 1.0 ||
        warped.y < 0.0 || warped.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    // Low-res sampling — quantize to 240p, preserving aspect ratio
    float targetHeight = 240.0;
    float aspect = uSize.x / uSize.y;
    vec2 grid = vec2(targetHeight * aspect, targetHeight);
    vec2 lowResUV = floor(warped * grid) / grid;

    vec4 tex = texture(uTexture, lowResUV);
    vec3 col = tex.rgb;

    // Desaturate
    float luma = dot(col, vec3(0.299, 0.587, 0.114));
    col = mix(vec3(luma), col, uSaturation);

    // Scanlines
    float scan = sin(warped.y * uSize.y * 3.14159) * 0.5 + 0.5;
    col *= 1.0 - uScanline * (1.0 - scan);

    // Vignette
    vec2 d = warped - 0.5;
    col *= 1.0 - uVignette * dot(d, d) * 3.5;

    // Flicker
    col *= 0.97 + 0.09 * sin(uTime * 3.0);

    // Film grain
    float noise = fract(sin(dot(warped + fract(uTime), vec2(127.1, 311.7))) * 43758.5453);
    col += 0.015 * (noise - 0.5);

    fragColor = vec4(clamp(col, 0.0, 1.0), tex.a);
}