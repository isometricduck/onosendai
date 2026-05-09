#include <flutter/runtime_effect.glsl>

uniform sampler2D u_image;
uniform vec2 u_resolution;
uniform float u_lineSpacing;
uniform float u_lineIntensity;
uniform vec3 u_fgColor;
uniform vec3 u_bgColor;

out vec4 fragColor;

void main() {
	vec2 fragCoord = FlutterFragCoord().xy;
	vec2 uv = fragCoord / u_resolution;

	vec4 color = texture(u_image, uv);
	float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

	float mask = mix(1.0 - u_lineIntensity, 1.0, step(0.5, fract(fragCoord.y / u_lineSpacing)));

	float intensity = clamp(gray * mask, 0.0, 1.0);
	vec3 finalColor = mix(u_bgColor, u_fgColor, intensity);

	fragColor = vec4(finalColor, 1.0);
}
