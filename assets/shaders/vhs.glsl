#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float uNoise;
uniform float uChroma;
uniform float uScanLines;
uniform float uJitter;
uniform float uRollLines;
uniform float uVignette;
uniform sampler2D uTexture;

out vec4 fragColor;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;

    // Horizontal jitter per scanline
    float jitterSeed = floor(uv.y * uSize.y) / uSize.y;
    float jitter = (rand(vec2(jitterSeed, uTime * 0.8)) - 0.5) * 2.0;
    float jitterAmt = uJitter * pow(rand(vec2(uTime * 0.3, jitterSeed)), 3.0);
    uv.x += jitter * jitterAmt;

    // Tape roll distortion bands
    float rollBand = sin(uv.y * 8.0 - uTime * 2.5) * 0.5 + 0.5;
    rollBand *= step(0.92, rollBand);
    uv.x += rollBand * uRollLines * 0.04;
    uv.y += rollBand * uRollLines * 0.003;

    // Clamp to prevent sampling outside
    uv = clamp(uv, 0.0, 1.0);

    // Chromatic aberration (R/B shift)
    float caX = uChroma * (1.0 + rollBand * 3.0);
    float r = texture(uTexture, uv + vec2( caX, 0.0)).r;
    float g = texture(uTexture, uv              ).g;
    float b = texture(uTexture, uv - vec2( caX, 0.0)).b;
    vec3 col = vec3(r, g, b);

    // Luminance noise / static
    float n = rand(uv + fract(uTime * 3.7));
    col += (n - 0.5) * uNoise;

    // Scan lines
    float scan = sin(uv.y * uSize.y * 3.14159) * 0.5 + 0.5;
    col *= mix(1.0, scan, uScanLines * 0.6);

    // Horizontal stripe noise (tape damage)
    float stripe = step(0.985, rand(vec2(floor(uv.y * 60.0), floor(uTime * 12.0))));
    col = mix(col, vec3(rand(vec2(uTime, uv.y))), stripe * uNoise);

    // Vignette
    vec2 vig = uv * (1.0 - uv.yx);
    float vigAmt = pow(vig.x * vig.y * 15.0, uVignette);
    col *= vigAmt;

    // Slight warm shift (VHS color bleed)
    col.r *= 1.04;
    col.b *= 0.93;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}