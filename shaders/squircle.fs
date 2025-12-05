#version 460
precision highp float;
precision highp sampler2D;

in vec2 fragTexCoord;
in vec4 fragColor;
out vec4 finalColor;

uniform vec2 resolution;

// rect = (a, b, w, h)
uniform vec4 rect;
// round = (r, n)
uniform vec4 round;
uniform vec4 albedo;
uniform vec4 emission;
uniform sampler2D backBuffer;

void main() {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv = clamp(uv, 0.0, 1.0);
	float a = rect.x;
	float w = rect.z;
	float h = rect.w;
	float b = rect.y;

	float r = round.x;
	float n = round.y;

	// Compute squircle mask
	vec2 pos = gl_FragCoord.xy;
	float cx = min(r, w*0.5)/(w*0.5);
	float cy = min(r, h*0.5)/(h*0.5);
	float nx = abs((2.0 * pos.x - (2.0 * a + w)) / w);
	float ny = abs((2.0 * pos.y - (2.0 * b + h)) / h);
	float dx = max(nx - (1.0 - cx), 0.0) / cx;
	float dy = max(ny - (1.0 - cy), 0.0) / cy;
	float inside = pow(dx, n) + pow(dy, n);
	float px = (1.0 / length(resolution.xy));
	float mask = smoothstep(0.0, 1.0, max(0.0, 1.0 - pow(inside, radius / 2.0)));

	finalColor = mix(texture2D(backBuffer, uv), texture2D(backBuffer, uv) * albedo + emission, mask);
}
