module bismuth.screen;

import cobalt;
import sodium;
import raylib;
import std.stdio;
import std.algorithm;
import std.math;
import std.math : PI;
import std.conv;
import std.string;

import bismuth.effect.base;
import bismuth.effect.blur;
import bismuth.effect.glass;
import bismuth.effect.squircle;
import bismuth.effect.fade : Fade;
import bismuth.workspace;
import bismuth.window;
import bismuth.tab;
import bismuth.element;

public static class Screen : Effect {
	public static Vector2 size;
	public static Vector2 physicalSize;
	
	public static RenderTexture2D front;
	public static RenderTexture2D middle;
	public static RenderTexture2D back;
	public static Texture2D       wallpaper;

	public static void load () {
		writeln("Preparing screen...");
		SetConfigFlags(
			ConfigFlags.FLAG_WINDOW_ALWAYS_RUN
			| ConfigFlags.FLAG_WINDOW_UNDECORATED
			| ConfigFlags.FLAG_FULLSCREEN_MODE
		);
		InitWindow(0, 0, "Bismuth root");

		Screen.size = Vector2(
			GetScreenWidth(),
			GetScreenHeight(),
		);

		Screen.physicalSize = Vector2(
			GetMonitorPhysicalWidth(GetCurrentMonitor()),
			GetMonitorPhysicalHeight(GetCurrentMonitor()),
		);

		back = LoadRenderTexture(GetScreenWidth(), GetScreenHeight());
		SetTextureFilter(back.texture, TextureFilter.TEXTURE_FILTER_BILINEAR);
		front = LoadRenderTexture(GetScreenWidth(), GetScreenHeight());
		SetTextureFilter(front.texture, TextureFilter.TEXTURE_FILTER_BILINEAR);
		middle = LoadRenderTexture(GetScreenWidth(), GetScreenHeight());
		SetTextureFilter(middle.texture, TextureFilter.TEXTURE_FILTER_BILINEAR);
		SetTargetFPS(GetMonitorRefreshRate(GetCurrentMonitor()));

		import std.file : exists;
		exists("wallpaper.png")
		? (wallpaper = LoadTexture("wallpaper.png"))
		: (wallpaper = LoadTexture("wallpaper.jpg"))
		;
		writeln("=== WALLPAPER IS TEXTURE "~to!string(wallpaper.id)~" ===");
		GenTextureMipmaps(&wallpaper);
		SetTextureFilter(wallpaper, TextureFilter.TEXTURE_FILTER_TRILINEAR);

		Workspace.load();
		Window.load();
		Squircle.load();
		Fade.load();
		Blur.load();
		Glass.load();
		oldrect = Glass.rect;

		DisableCursor();

		while (!WindowShouldClose()) Screen.draw();

		Screen.unload();
	}

	public static void unload () {
		EnableCursor();
		Glass.unload();
		Blur.unload();
		UnloadRenderTexture(front);
		UnloadRenderTexture(middle);
		UnloadRenderTexture(back);
		CloseWindow();
	}

	private static void feed () {
		BeginTextureMode(Screen.back);
			DrawTexturePro(
				Screen.front.texture,
				Rectangle(0, 0, Screen.size.x, -Screen.size.y),
				Rectangle(0, 0, Screen.size.x, Screen.size.y),
				Vector2(0, 0),
				0,
				Colors.WHITE,
			);
		EndTextureMode();
	}

	private static Rectangle oldrect = Rectangle();

	public static void draw () {
		BeginTextureMode(Screen.back);
			DrawTexturePro(Screen.wallpaper,
				Rectangle(0, 0, Screen.wallpaper.width, Screen.wallpaper.height),
				Rectangle(0, 0, Screen.size.x, Screen.size.y),
				Vector2(0, 0),
				0,
				Colors.WHITE,
			);
			ClearBackground(Colors.BLACK);
			DrawTexturePro(
				wallpaper,
				Rectangle(0, 0, wallpaper.width, wallpaper.height),
				Rectangle(0, 0, Screen.size.x, Screen.size.y),
				Vector2(0, 0),
				0,
				Colors.WHITE,
			);
		EndTextureMode();

		Vector2 delta = GetMouseDelta();
		Glass.rect = oldrect;
		if (IsKeyDown(KeyboardKey.KEY_LEFT_ALT)) {
			if (IsKeyDown(KeyboardKey.KEY_LEFT_SHIFT))
				Glass.power += delta.x / 16.0;
			else
				Glass.radius += delta.x / 4.0;
		} else if (IsKeyDown(KeyboardKey.KEY_LEFT_CONTROL)) {
			Glass.rect.w += delta.x;
			Glass.rect.h += delta.y;
		} else if (IsKeyDown(KeyboardKey.KEY_LEFT_SHIFT)) {
			Glass.rect += delta;
		}
		Glass.blur = 32.0;
		Glass.draw(Screen.back.texture, Screen.front);
		feed();
		oldrect = Glass.rect;
		Glass.rect.x += 256;
		Glass.rect.y += 256;
		Glass.draw(Screen.back.texture, Screen.front);
		feed();
		
		//Fade.radius = Glass.radius;
		//Fade.power = Glass.power;
		//Fade.rect = Rectangle(Glass.rect.x + Glass.radius, Glass.rect.y + Glass.radius, Glass.rect.w - Glass.radius * 2.0, Glass.rect.h - Glass.radius * 2.0);
		//Fade.rect = Rectangle(0, 0, 200, 200);
		//Fade.albedo = Vector4(0.0, 0.0, 0.0, 0.0);
		//Fade.emission = Vector4(0.1, 0.1, 0.1, 1.0);
		//Fade.draw(Screen.back.texture, Screen.front);
		//feed();

		BeginDrawing();
			ClearBackground(Colors.BLANK);
			DrawTexturePro(Screen.wallpaper,
				Rectangle(0, 0, Screen.wallpaper.width, Screen.wallpaper.height),
				Rectangle(0, 0, Screen.size.x, Screen.size.y),
				Vector2(0, 0),
				0,
				Colors.WHITE,
			);
			DrawTexturePro(Screen.back.texture,
				Rectangle(0, 0, Screen.size.x, -Screen.size.y),
				Rectangle(0, 0, Screen.size.x, Screen.size.y),
				Vector2(0, 0),
				0,
				Colors.WHITE,
			);
			DrawFPS(0, 0);

			DrawText("Hold shift to move".ptr,                   0,  32, 32, Colors.WHITE);
			DrawText("Hold control to resize".ptr,               0,  64, 32, Colors.WHITE);
			DrawText("Hold alt to change radius".ptr,                    0,  96, 32, Colors.WHITE);
			DrawText("Hold shift alt to change power".ptr,                    0,  128, 32, Colors.WHITE);
			DrawText(("radius: " ~ to!string(Glass.radius)).toStringz, 0, 160, 32, Colors.WHITE);
			DrawText(("power: " ~ to!string(Glass.power)).toStringz, 0, 192, 32, Colors.WHITE);
		EndDrawing();
	}
}
