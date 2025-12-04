#version 460
precision highp float;
precision highp sampler2D;

in vec2 fragTexCoord;
in vec4 fragColor;
out vec4 finalColor;

uniform vec2 resolution;

uniform float angle;
uniform float radius;
uniform float samples;
uniform sampler2D backBuffer;

vec4 safeSample (sampler2D tex, vec2 position) {
	vec2 clamped = clamp(position, vec2(0.0), vec2(1.0));
	vec2 overshoot = position - clamped;
	return texture(tex, clamped - overshoot);
}

void main() {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv = clamp(uv, 0.0, 1.0);

	float px = (1.0 / length(resolution.xy));

	vec4 blurred = vec4(0.0);

	for (float rStep = -samples / 2; rStep < samples/2; rStep++) {
		float offset = (rStep / samples) * radius;
		vec2 dir = vec2(cos(angle), sin(angle));
		
		blurred += safeSample(backBuffer, uv + dir * offset * px);
	}

	finalColor = blurred / samples;
	finalColor.a = 1.0;
}
