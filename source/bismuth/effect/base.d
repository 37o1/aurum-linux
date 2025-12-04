module bismuth.effect.base;

public import raylib;

public interface Effect {
	static void draw (Texture2D input, RenderTexture2D output);
}

public class ShaderUniform (T) {
	int loc;
	ShaderUniformDataType type;
	Shader shader;
	this (Shader shader, string name, ShaderUniformDataType type) {
		loc = GetShaderLocation(shader, name.ptr);
		this.type = type; this.shader = shader;
	}

	void set (T data) inout {
		SetShaderValue(cast (Shader) shader, loc, &data, type);
	}
}