module bismuth.effect.glass;
import bismuth.effect.base;
import bismuth.effect.blur;
import bismuth.screen;
import std.algorithm;
import std.math;
import std.math : PI;

public static class Glass : Effect {
	private static Shader shader;
	private static ShaderUniform!Vector4 rectLoc;
	private static ShaderUniform!Vector2 cLoc;
	private static ShaderUniform!Vector2 resolutionLoc;
	private static ShaderUniform!float   radiusLoc;
	private static ShaderUniform!float   powerLoc;
	private static ShaderUniform!Vector4 emissionLoc;
	private static ShaderUniform!Vector4 albedoLoc;
	private static ShaderUniform!float   sheenRotLoc;
	private static int                   backBufferLoc;

	static void load () {
		shader        = LoadShader("shaders/base.vs".ptr, ("shaders/glass.fs").ptr);
		rectLoc       = new ShaderUniform!(Vector4)(shader, "rect", ShaderUniformDataType.SHADER_UNIFORM_VEC4);
		cLoc          = new ShaderUniform!(Vector2)(shader, "c", ShaderUniformDataType.SHADER_UNIFORM_VEC2);
		resolutionLoc = new ShaderUniform!(Vector2)(shader, "resolution", ShaderUniformDataType.SHADER_UNIFORM_VEC2);
		radiusLoc     = new ShaderUniform!(float)(shader, "radius", ShaderUniformDataType.SHADER_UNIFORM_FLOAT);
		powerLoc      = new ShaderUniform!(float)(shader, "power", ShaderUniformDataType.SHADER_UNIFORM_FLOAT);
		albedoLoc     = new ShaderUniform!(Vector4)(shader, "albedo", ShaderUniformDataType.SHADER_UNIFORM_VEC4);
		emissionLoc   = new ShaderUniform!(Vector4)(shader, "emission", ShaderUniformDataType.SHADER_UNIFORM_VEC4);
		sheenRotLoc   = new ShaderUniform!(float)(shader, "sheenRot", ShaderUniformDataType.SHADER_UNIFORM_FLOAT);
		backBufferLoc = GetShaderLocation(shader, "backBuffer");
		blurDropOff   = LoadRenderTexture(GetScreenWidth(), GetScreenHeight());
		SetTextureFilter(blurDropOff.texture, TextureFilter.TEXTURE_FILTER_BILINEAR);
		rect = Rectangle(Screen.size.x/3.0, Screen.size.y/3.0, Screen.size.x/3.0, Screen.size.y/3.0);
		radius = min(Screen.size.x, Screen.size.y)/6.0;
	}

	static void unload () {
		UnloadShader(shader);
	}

	static Rectangle rect = Rectangle(256, 256, 64, 64);
	static float radius = 64;
	static float blur = 64;
	static float power = 3;
	static Vector4 albedo = Vector4(0.97, 0.98, 0.99, 1);
	static Vector4 emission = Vector4(0, 0, 0, 0);
	static float sheenRot = 3.141 * 1.75;

	static RenderTexture blurDropOff;

	static void draw (Texture2D input, RenderTexture2D output) {
		radius = max(0.0, radius);
		rect.w = max(radius * 2, rect.w);
		rect.h = max(radius * 2, rect.h);
		Blur.rect = rect;
		Blur.rect.x = rect.x - 512.0;
		Blur.rect.y = rect.y - 512.0;
		Blur.rect.w = rect.w + 1024.0;
		Blur.rect.h = rect.h + 1024.0;
		Blur.radius = blur;
		Blur.rSamples = min(32.0, max(1.0, ceil(Blur.radius / PI)));
		Blur.aSamples = 3;
		Blur.draw(input, blurDropOff);

		BeginTextureMode(output);
			ClearBackground(Colors.BLANK);
			BeginShaderMode(shader);
				rectLoc.set(Vector4(rect.x, Screen.size.y - rect.y, rect.width, -rect.height));
				cLoc.set(Vector2(
					radius / (rect.w * 0.5f),
					radius / (rect.h * 0.5f)
				));
				resolutionLoc.set(Vector2(output.texture.width, output.texture.height));
				radiusLoc.set(radius);
				powerLoc.set(power);
				albedoLoc.set(albedo);
				emissionLoc.set(emission);
				sheenRotLoc.set(sheenRot);
				SetShaderValueTexture(shader, backBufferLoc, blurDropOff.texture);
				DrawRectanglePro(rect, Vector2(0, 0), 0.0f, Colors.WHITE);
			EndShaderMode();
		EndTextureMode();
	}
}