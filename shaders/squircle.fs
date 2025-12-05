#version 460
precision highp float;
precision highp sampler2D;

in vec2 fragTexCoord;
in vec4 fragColor;
out vec4 finalColor;

uniform vec2 resolution;

uniform vec4 rect;
uniform float radius;
uniform float power;
uniform vec4 albedo;
uniform vec4 emission;
uniform sampler2D backBuffer;

void main() {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv = clamp(uv, 0.0, 1.0);

	// Compute squircle mask
	float nx = abs((2.0 * gl_FragCoord.x - (2.0 * rect.x + rect.z)) / rect.z);
	float ny = abs((2.0 * gl_FragCoord.y - (2.0 * rect.y + rect.w)) / rect.w);
	float dx = abs(max(nx - (1.0 - c.x), 0.0) / c.x);
	float dy = abs(max(ny - (1.0 - c.y), 0.0) / c.y);
	float inside = pow(dx, power) + pow(dy, power);
	float px = (1.0 / length(resolution.xy));
	float mask = smoothstep(0.0, 1.0, max(0.0, 1.0 - pow(inside, radius / 2.0)));

	finalColor = mix(texture2D(backBuffer, uv), texture2D(backBuffer, uv) * albedo + emission, mask);
}
