module bismuth.effect.squircle;
import bismuth.effect.base;
import bismuth.screen;
import std.algorithm;
import std.math;
import std.math : PI;

public static class Squircle : Effect {
	private static Shader shader;
	private static ShaderUniform!Vector4 rectLoc;
	private static ShaderUniform!Vector2 resolutionLoc;
	private static ShaderUniform!float   radiusLoc;
	private static ShaderUniform!float   powerLoc;
	private static ShaderUniform!Vector4 emissionLoc;
	private static ShaderUniform!Vector4 albedoLoc;
	private static int                   backBufferLoc;

	static void load () {
		shader        = LoadShader("shaders/base.vs".ptr, ("shaders/squircle.fs").ptr);
		rectLoc       = new ShaderUniform!(Vector4)(shader, "rect", ShaderUniformDataType.SHADER_UNIFORM_VEC4);
		resolutionLoc = new ShaderUniform!(Vector2)(shader, "resolution", ShaderUniformDataType.SHADER_UNIFORM_VEC2);
		radiusLoc     = new ShaderUniform!(float)(shader, "radius", ShaderUniformDataType.SHADER_UNIFORM_FLOAT);
		powerLoc      = new ShaderUniform!(float)(shader, "power", ShaderUniformDataType.SHADER_UNIFORM_FLOAT);
		albedoLoc     = new ShaderUniform!(Vector4)(shader, "albedo", ShaderUniformDataType.SHADER_UNIFORM_VEC4);
		emissionLoc   = new ShaderUniform!(Vector4)(shader, "emission", ShaderUniformDataType.SHADER_UNIFORM_VEC4);
		backBufferLoc = GetShaderLocation(shader, "backBuffer");
	}

	static void unload () {
		UnloadShader(shader);
	}

	static Rectangle rect;
	static float radius;
	static float power;
	static Vector4 albedo;
	static Vector4 emission;

	static void draw (Texture2D input, RenderTexture2D output) {
		radius = max(0.0, radius);
		rect.w = max(radius * 2, rect.w);
		rect.h = max(radius * 2, rect.h);
		
		BeginTextureMode(output);
			ClearBackground(Colors.BLANK);
			BeginShaderMode(shader);
				rectLoc.set(Vector4(rect.x, Screen.size.y - rect.y, rect.width, rect.height));
				resolutionLoc.set(Vector2(output.texture.width, output.texture.height));
				radiusLoc.set(radius);
				powerLoc.set(power);
				albedoLoc.set(albedo);
				emissionLoc.set(emission);
				SetShaderValueTexture(shader, backBufferLoc, input);
				DrawRectanglePro(rect, Vector2(0, 0), 0.0f, Colors.WHITE);
			EndShaderMode();
				debug { import std.stdio : writeln; try { writeln("=="); } catch (Exception) {} }
		EndTextureMode();
	}
}