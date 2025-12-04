module bismuth.workspace;

import bismuth.window;
import sodium;

public class Workspace {
	static Set!Workspace all;

	Set!Window windows;

	string name;
	int id = -1;
	int fps = 0;

	this (int id_) {
		this.id = id_;
		this.windows = new Set!Window;
	}

	static load () {
		Workspace.all = new Set!Workspace;
	}
}
