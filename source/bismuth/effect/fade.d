module bismuth.effect.fade;
import bismuth.effect.base;
import bismuth.screen;
import std.algorithm;
import std.math : PI;

/*
## ## ##### ####  ##  ##       ## ## ## ####
## ## ##    ## ## ##  ##       ## ## ## ## ##
## ## ##### ####   ####        ##### ## ####
 ###  ##    ## ##   ##         ## ## ## ##
  #   ##### ## ##   ##         #   # ## ##

This is gonna be changed into a gradient blur
*/

public static class Fade : Effect {
	private static Shader shader;
	private static ShaderUniform!float   angleLoc;
	private static ShaderUniform!float   samplesLoc;
	private static ShaderUniform!float   radiusLoc;
	private static ShaderUniform!Vector2 resolutionLoc;
	private static int                   backBufferLoc;
	private static int                   replaceBufferLoc;
	
	static void load () {
		shader     = LoadShader("shaders/base.vs".ptr, ("shaders/fade.fs").ptr);
		angleLoc   = new ShaderUniform!float(shader, "angle",   ShaderUniformDataType.SHADER_UNIFORM_FLOAT);
		backBufferLoc    = GetShaderLocation(shader, "backBuffer");
		replaceBufferLoc = GetShaderLocation(shader, "replaceBuffer");
	}
	
	static void unload () {
		UnloadShader(shader);
	}

	static Rectangle rect = Rectangle(0, 0, 0, 0);
	static float angle = 0.0;
	static ref Texture2D replace = Texture();
	
	static void draw (Texture2D input, RenderTexture2D output) {
		BeginTextureMode(output);
			BeginShaderMode(shader);
				angleLoc.set(angle);
				SetShaderValueTexture(shader, backBufferLoc, input);
				SetShaderValueTexture(shader, replaceBufferLoc, replace);
				DrawRectanglePro(rect, Vector2(), 0.0f, Colors.WHITE);
			EndShaderMode();
		EndTextureMode();
	}
}