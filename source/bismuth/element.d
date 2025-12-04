module bismuth.element;

import bismuth.tab;
import sodium;

public interface Renderable {
	void draw ();
}

public class Card : Renderable {
	Tab tab;

	void draw () {}
}

public class Canvas : Renderable {
	void draw () {}
}

