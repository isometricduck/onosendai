#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

vec3 cgaPalette0(vec3 color) {
    // CGA Palette 0
    // 0: Black    #000000
    // 1: Green    #55FF55
    // 2: Red      #FF5555
    // 3: Yellow   #FFFF55
    float luma = dot(color, vec3(0.299, 0.587, 0.114));

    if (luma < 0.15)       return vec3(0.000, 0.000, 0.000); // black
    else if (luma < 0.45)  return vec3(0.999, 0.333, 0.333); // red
    else if (luma < 0.72)  return vec3(0.999, 0.999, 0.333); // yellow
    else                   return vec3(0.333, 0.999, 0.333); // green
}

void main() {
    // FlutterFragCoord() gives pixel coords in logical pixels
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uSize;

    // Compute pixelated resolution: 200p on the shorter axis, preserve aspect ratio
    float aspect = uSize.x / uSize.y;
    float targetShort = 200.0;
    float pixW, pixH;
    if (uSize.x < uSize.y) {
        pixW = targetShort;
        pixH = targetShort / aspect;
    } else {
        pixH = targetShort;
        pixW = targetShort * aspect;
    }

    // Snap UV to pixelated grid
    vec2 pixelatedUV = (floor(uv * vec2(pixW, pixH)) + 0.5) / vec2(pixW, pixH);

    vec3 color = texture(uTexture, pixelatedUV).rgb;
    vec3 cga = cgaPalette0(color);
    fragColor = vec4(cga, 1.0);
}
