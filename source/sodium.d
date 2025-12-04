module sodium;

public class Map (K, V) {
	import std.typecons : Tuple;
	alias Entry = Tuple!(K, V);

	private V[K] store = (V[K]).init;
	public V get (K key) { return store[key]; }
	public void set (K key, V value) { store[key] = value; }
	public bool has (K key) { return (key in store) != null; }
	public void remove (K key) { store.remove(key); }
	public K[] keys () {
		K[] bucket = [];
		bucket.reserve(store.length);
		foreach (K key, V _; store) bucket ~= key;
		return bucket;
	}
	
	public V[] values () {
		V[] bucket = [];
		bucket.reserve(store.length);
		foreach (K _, V value; store) bucket ~= value;
		return bucket;
	}
	
	public Entry[] entries () {
		Entry[] bucket;
		bucket.reserve(store.length);
		foreach (K key, V value; store) bucket ~= Entry(key, value);
		return bucket;
	}

	alias Mapper = void delegate (K, V);
	public void map (Mapper mapper) {
		foreach (K key, V value; store) mapper(key, value);
	}
}

public class Set (T) {
	private int[T] store = (int[T]).init;
	public void add (T item) { store[item] = 0; }
	public bool has (T item) { return (item in store) != null; }
	public void remove (T item) { store.remove(item); }
	public T[] items () {
		T[] bucket = [];
		foreach (T item, int _; store) bucket ~= item;
		return bucket;
	}
	alias Mapper = void delegate (T);
	public void map (Mapper mapper) {
		foreach (T item, int _; store) mapper(item);
	}
}

public class Volume {
	static Map!(string, Volume) loaded;
	
	Map!(string, Namespace) namespaces;
}

public class Namespace {
	static Map!(string, Namespace) loaded;

	Volume volume;
	Map!(string, Collection) cachedCollections;
}

public class Collection {
	static Map!(string, Collection) loaded;

	Namespace namespace;
	Map!(string, Item) cachedItems;
}

public class Item {
	static Map!(string, Item) loaded;

	Collection collection;
}
