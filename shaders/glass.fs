#version 460
precision highp float;
precision highp sampler2D;

in vec2 fragTexCoord;
in vec4 fragColor;
out vec4 finalColor;

uniform vec2 resolution;

uniform vec4 rect;
uniform vec2 c;
uniform float sheenRot;
uniform float radius;
uniform float power;
uniform vec4 albedo;
uniform vec4 emission;
uniform sampler2D backBuffer;

vec4 safeSample (sampler2D tex, vec2 position) {
	vec2 clamped = clamp(position, vec2(0.0), vec2(1.0));
	vec2 overshoot = position - clamped;
	return texture(tex, clamped - overshoot);
}

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

	float pinside = pow(inside, 2.0);

	vec2 p = gl_FragCoord.xy;
	// rectangle center
	vec2 rc = rect.xy + rect.zw * 0.5;
	// symmetric center-relative coordinate
	vec2 rectCenter = (p - rc) / (rect.zw * 8.0);
	rectCenter.y = -rectCenter.y;
	rectCenter *= pinside;

	vec4 refracted = vec4(0.0);

	vec2 offset = rectCenter * pinside;

	refracted.r =
	  safeSample(backBuffer, uv - offset * 0.95).r
	+ safeSample(backBuffer, uv + offset * 1.05).r * pinside * 0.2
	;
	
	refracted.g =
	  safeSample(backBuffer, uv - offset).g
	+ safeSample(backBuffer, uv + offset).g * pinside * 0.2
	;
	
	refracted.b =
	  safeSample(backBuffer, uv - offset * 1.05).b
	+ safeSample(backBuffer, uv + offset * 0.95).b * pinside * 0.2
	;
	
	refracted.a = 1.0;

	finalColor = vec4((
		refracted * albedo
		+ emission
		+ abs(dot(rectCenter, vec2(sin(sheenRot), cos(sheenRot))))
		* pow(inside, 16.0 + log(pow(radius, 2.0))) * (8.0 + 8.0 / radius) * mask
	).rgb, mask);
}
