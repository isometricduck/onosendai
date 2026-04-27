#include <flutter/runtime_effect.glsl>

uniform sampler2D u_image;
uniform vec2 u_resolution;
uniform float u_pixelSize;
uniform float u_ditherAmount;
uniform float u_bitDepth;
uniform float u_contrast;
uniform vec3 u_fgColor;
uniform vec3 u_bgColor;

out vec4 fragColor;

float bayer8x8(vec2 pos) {
	int x = int(mod(pos.x, 8.0));
	int y = int(mod(pos.y, 8.0));
	int idx = y * 8 + x;

	if (idx == 0) return 0.0 / 64.0;
	else if (idx == 1) return 32.0 / 64.0;
	else if (idx == 2) return 8.0 / 64.0;
	else if (idx == 3) return 40.0 / 64.0;
	else if (idx == 4) return 2.0 / 64.0;
	else if (idx == 5) return 34.0 / 64.0;
	else if (idx == 6) return 10.0 / 64.0;
	else if (idx == 7) return 42.0 / 64.0;
	else if (idx == 8) return 48.0 / 64.0;
	else if (idx == 9) return 16.0 / 64.0;
	else if (idx == 10) return 56.0 / 64.0;
	else if (idx == 11) return 24.0 / 64.0;
	else if (idx == 12) return 50.0 / 64.0;
	else if (idx == 13) return 18.0 / 64.0;
	else if (idx == 14) return 58.0 / 64.0;
	else if (idx == 15) return 26.0 / 64.0;
	else if (idx == 16) return 12.0 / 64.0;
	else if (idx == 17) return 44.0 / 64.0;
	else if (idx == 18) return 4.0 / 64.0;
	else if (idx == 19) return 36.0 / 64.0;
	else if (idx == 20) return 14.0 / 64.0;
	else if (idx == 21) return 46.0 / 64.0;
	else if (idx == 22) return 6.0 / 64.0;
	else if (idx == 23) return 38.0 / 64.0;
	else if (idx == 24) return 60.0 / 64.0;
	else if (idx == 25) return 28.0 / 64.0;
	else if (idx == 26) return 52.0 / 64.0;
	else if (idx == 27) return 20.0 / 64.0;
	else if (idx == 28) return 62.0 / 64.0;
	else if (idx == 29) return 30.0 / 64.0;
	else if (idx == 30) return 54.0 / 64.0;
	else if (idx == 31) return 22.0 / 64.0;
	else if (idx == 32) return 3.0 / 64.0;
	else if (idx == 33) return 35.0 / 64.0;
	else if (idx == 34) return 11.0 / 64.0;
	else if (idx == 35) return 43.0 / 64.0;
	else if (idx == 36) return 1.0 / 64.0;
	else if (idx == 37) return 33.0 / 64.0;
	else if (idx == 38) return 9.0 / 64.0;
	else if (idx == 39) return 41.0 / 64.0;
	else if (idx == 40) return 51.0 / 64.0;
	else if (idx == 41) return 19.0 / 64.0;
	else if (idx == 42) return 59.0 / 64.0;
	else if (idx == 43) return 27.0 / 64.0;
	else if (idx == 44) return 49.0 / 64.0;
	else if (idx == 45) return 17.0 / 64.0;
	else if (idx == 46) return 57.0 / 64.0;
	else if (idx == 47) return 25.0 / 64.0;
	else if (idx == 48) return 15.0 / 64.0;
	else if (idx == 49) return 47.0 / 64.0;
	else if (idx == 50) return 7.0 / 64.0;
	else if (idx == 51) return 39.0 / 64.0;
	else if (idx == 52) return 13.0 / 64.0;
	else if (idx == 53) return 45.0 / 64.0;
	else if (idx == 54) return 5.0 / 64.0;
	else if (idx == 55) return 37.0 / 64.0;
	else if (idx == 56) return 63.0 / 64.0;
	else if (idx == 57) return 31.0 / 64.0;
	else if (idx == 58) return 55.0 / 64.0;
	else if (idx == 59) return 23.0 / 64.0;
	else if (idx == 60) return 61.0 / 64.0;
	else if (idx == 61) return 29.0 / 64.0;
	else if (idx == 62) return 53.0 / 64.0;
	else return 21.0 / 64.0;
}

float random(vec2 st) {
	return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
	// FlutterFragCoord() replaces gl_FragCoord in Flutter shaders
	vec2 fragCoord = FlutterFragCoord().xy;
	vec2 uv = fragCoord / u_resolution;

	vec2 pixelatedUV = floor(uv * u_resolution / u_pixelSize) * u_pixelSize / u_resolution;

	vec4 color = texture(u_image, pixelatedUV);

	float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

	gray = (gray - 0.5) * u_contrast + 0.5;
	gray = clamp(gray, 0.0, 1.0);

	vec2 pixelPos = floor(fragCoord);
	float bayerValue = bayer8x8(pixelPos);

	float noise = random(pixelPos * 0.01) * 0.1;
	bayerValue = mix(bayerValue, noise, 0.3);

	float threshold = mix(0.5, bayerValue, u_ditherAmount);
	float dithered = step(threshold, gray);

	float levels = pow(2.0, u_bitDepth);
	float quantized = floor(gray * levels) / levels;

	float final_val = mix(quantized, dithered, u_ditherAmount);

	vec3 finalColor = mix(u_bgColor, u_fgColor, final_val);

	fragColor = vec4(finalColor, 1.0);
}
