module bismuth.window;

import bismuth.workspace;
import bismuth.tab;
import sodium;

import raylib : Rectangle;

public class Window {
	static Set!Window all;
	
	Workspace workspace;
	Set!Tab tabs;

	Rectangle rect = Rectangle();

	this (Workspace workspace_) {
		this.workspace = workspace_;
		this.tabs = new Set!Tab;
	}

	static load () {
		Window.all = new Set!Window;
	}
}
