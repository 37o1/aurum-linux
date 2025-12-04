#version 330

// input vertex attributes
in vec3 vertexPosition;
in vec2 vertexTexCoord;
in vec3 vertexNormal;
in vec4 vertexColor;

// input uniform values
uniform mat4 mvp;

// output vertex attributes (to fragment shader)
out vec2 fragTexCoord;
out vec4 fragColor;

void main() {
    // send vertex attributes to fragment shader
    fragTexCoord = vertexTexCoord;
    fragColor = vertexColor;

    // calculate final vertex position
    gl_Position = mvp*vec4(vertexPosition, 1.0);
}