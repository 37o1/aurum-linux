#version 460
precision highp float;
precision highp sampler2D;

in vec2 fragTexCoord;
in vec4 fragColor;
out vec4 finalColor;

uniform float angle;
uniform sampler2D backBuffer;
uniform sampler2D replaceBuffer;

void main() {
	float mask = abs(dot(vec2(0.0, 0.0), vec2(sin(angle), cos(angle))));
	finalColor = vec4(mask);
}
