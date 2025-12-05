import std.stdio;
import core.sys.posix.unistd;

import sodium;

void main () {
	import core.thread;
	import bismuth.screen;
	new Thread(() => Screen.load()).start();
}
