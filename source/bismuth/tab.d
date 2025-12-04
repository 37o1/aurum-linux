module bismuth.tab;

import bismuth.window;
import bismuth.element;
import sodium;

public class Tab {
	Window window;
	Set!Renderable elements;

	this (Window window_) {
		this.window = window_;
		this.elements = new Set!Renderable;
	}
}
