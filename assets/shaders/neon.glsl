#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime; // seconds
uniform float uDither; // 0.0 = clean posterize, 1.0 = visible ordered dither
uniform float uBlend; // 0.0 = original texture, 1.0 = four-color palette
uniform float uPulseStrength; // 0.0 = no pulse, 1.0 = full blend pulse
uniform float uPulseSpeed; // cycles per second
uniform float uLuminanceBoost; // 0.0 = no boost, 1.0 = strong boost near palette colors
uniform sampler2D uTexture;


out vec4 fragColor;

const vec3 PALETTE_0 = vec3(0.02745098, 0.01960784, 0.06274510); // #070510
const vec3 PALETTE_1 = vec3(1.00000000, 0.16862745, 0.83921569); // #FF2BD6
const vec3 PALETTE_2 = vec3(0.23921569, 0.94117647, 1.00000000); // #3DF0FF
const vec3 PALETTE_3 = vec3(0.78431373, 1.00000000, 0.23921569); // #C8FF3D

vec3 srgbToLinear(vec3 c) {
    return pow(c, vec3(2.2));
}

vec3 linearToSrgb(vec3 c) {
    return pow(max(c, 0.0), vec3(1.0 / 2.2));
}

float bayer4(vec2 p) {
    ivec2 q = ivec2(mod(p, 4.0));
    int i = q.x + q.y * 4;

    if (i == 0) return 0.0 / 16.0;
    if (i == 1) return 8.0 / 16.0;
    if (i == 2) return 2.0 / 16.0;
    if (i == 3) return 10.0 / 16.0;
    if (i == 4) return 12.0 / 16.0;
    if (i == 5) return 4.0 / 16.0;
    if (i == 6) return 14.0 / 16.0;
    if (i == 7) return 6.0 / 16.0;
    if (i == 8) return 3.0 / 16.0;
    if (i == 9) return 11.0 / 16.0;
    if (i == 10) return 1.0 / 16.0;
    if (i == 11) return 9.0 / 16.0;
    if (i == 12) return 15.0 / 16.0;
    if (i == 13) return 7.0 / 16.0;
    if (i == 14) return 13.0 / 16.0;
    return 5.0 / 16.0;
}

float luminance(vec3 color) {
    return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

float paletteDistance(vec3 color, vec3 paletteColor) {
    float lumaDelta = luminance(color) - luminance(paletteColor);
    return lumaDelta * lumaDelta;
}

vec3 nearestPaletteColor(vec3 color) {
    vec3 p0 = srgbToLinear(PALETTE_0);
    vec3 p1 = srgbToLinear(PALETTE_1);
    vec3 p2 = srgbToLinear(PALETTE_2);
    vec3 p3 = srgbToLinear(PALETTE_3);

    float bestDistance = paletteDistance(color, p0);
    vec3 bestColor = p0;

    float distance1 = paletteDistance(color, p1);
    if (distance1 < bestDistance) {
        bestDistance = distance1;
        bestColor = p1;
    }

    float distance2 = paletteDistance(color, p2);
    if (distance2 < bestDistance) {
        bestDistance = distance2;
        bestColor = p2;
    }

    float distance3 = paletteDistance(color, p3);
    if (distance3 < bestDistance) {
        bestColor = p3;
    }

    return bestColor;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uSize;
    vec4 texel = texture(uTexture, uv);
    vec3 color = srgbToLinear(texel.rgb);

    float threshold = bayer4(fragCoord) - 0.5;
    color += threshold * 0.08 * clamp(uDither, 0.0, 1.0);

    vec3 nearestColor = nearestPaletteColor(color);
    float paletteCloseness = 1.0 - smoothstep(0.0, 0.18, sqrt(paletteDistance(color, nearestColor)));
    vec3 quantized = linearToSrgb(nearestColor);

    float pulse = sin(uTime * uPulseSpeed * 6.2831853) * 0.5 + 0.5;
    float pulseBlend = mix(1.0 - clamp(uPulseStrength, 0.0, 1.0), 1.0, pulse);
    float blendAmount = clamp(uBlend * pulseBlend, 0.0, 1.0);
    vec3 blended = mix(texel.rgb, quantized, blendAmount);

    float boostAmount = pulse * paletteCloseness * clamp(uLuminanceBoost, 0.0, 1.0);
    vec3 boosted = clamp(blended * (1.0 + boostAmount), 0.0, 1.0);
    fragColor = vec4(boosted, texel.a);
}
