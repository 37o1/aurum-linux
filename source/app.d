import std.stdio;
import core.sys.posix.unistd;

import sodium;

void main () {
	{
		alias StrMap = Map!(string, string);
		auto a = new StrMap;
		a.set("b", "c");
		assert(a.get("b") == "c");
		assert(a.has("b"));
		a.map((string k, string v) => writeln(k, " : ", v));
	}

	import core.thread;
	import bismuth.screen;
	new Thread(() => Screen.load()).start();
}
