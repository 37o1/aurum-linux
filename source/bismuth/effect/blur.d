module bismuth.effect.blur;
import bismuth.effect.base;
import bismuth.screen;
import std.algorithm;
import std.math : PI;

public static class Blur : Effect {
	private static Shader shader;
	private static ShaderUniform!float   angleLoc;
	private static ShaderUniform!float   samplesLoc;
	private static ShaderUniform!float   radiusLoc;
	private static ShaderUniform!Vector2 resolutionLoc;
	private static int                   backBufferLoc;
	
	static void load () {
		shader     = LoadShader("shaders/base.vs".ptr, ("shaders/directionalBlur.fs").ptr);
		angleLoc   = new ShaderUniform!float(shader, "angle",   ShaderUniformDataType.SHADER_UNIFORM_FLOAT);
		radiusLoc  = new ShaderUniform!float(shader, "radius",  ShaderUniformDataType.SHADER_UNIFORM_FLOAT);
		samplesLoc = new ShaderUniform!float(shader, "samples", ShaderUniformDataType.SHADER_UNIFORM_FLOAT);
		backBufferLoc = GetShaderLocation(shader, "backBuffer");
		resolutionLoc = new ShaderUniform!Vector2(shader, "resolution", ShaderUniformDataType.SHADER_UNIFORM_VEC2);
	}
	
	static void unload () {
		UnloadShader(shader);
	}

	static Rectangle rect = Rectangle(0, 0, 0, 0);
	static float radius = 16;
	static float aSamples = 3;
	static float rSamples = 16;
	
	static void draw (Texture2D input, RenderTexture2D output) {
		BeginTextureMode(Screen.middle);
			ClearBackground(Colors.BLANK);
			DrawTexturePro(
				input,
				Rectangle(0, 0, input.width, -input.height),
				Rectangle(0, 0, Screen.middle.texture.width, Screen.middle.texture.height),
				Vector2(),
				0.0f,
				Colors.WHITE,
			);
		EndTextureMode();
		for (float phi = 0; phi < PI; phi += PI / aSamples) {
			BeginTextureMode(output);
				ClearBackground(Colors.BLANK);
				BeginShaderMode(shader);
					angleLoc.set(phi);
					radiusLoc.set(radius);
					samplesLoc.set(rSamples);
					resolutionLoc.set(Vector2(output.texture.width, output.texture.height));
					SetShaderValueTexture(shader, backBufferLoc, Screen.middle.texture);
					DrawRectanglePro(rect, Vector2(), 0.0f, Colors.WHITE);
				EndShaderMode();
			EndTextureMode();
			BeginTextureMode(Screen.middle);
			DrawTexturePro(
				output.texture,
				Rectangle(0, 0, output.texture.width, -output.texture.height),
				Rectangle(0, 0, Screen.middle.texture.width, Screen.middle.texture.height),
				Vector2(),
				0.0f,
				Colors.WHITE,
			);
			EndTextureMode();
		}
		BeginTextureMode(output);
		DrawTexturePro(
			Screen.middle.texture,
			Rectangle(0, 0, output.texture.width, -output.texture.height),
			Rectangle(0, 0, Screen.middle.texture.width, Screen.middle.texture.height),
			Vector2(),
			0.0f,
			Colors.WHITE,
		);
		EndTextureMode();
	}
}