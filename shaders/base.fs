#version 460
precision highp float;
precision highp sampler2D;

in vec2 fragTexCoord;
in vec4 fragColor;
out vec4 finalColor;

uniform vec4 color;

void main() {
	finalColor = color;
}
