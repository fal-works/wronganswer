package wronganswer;

class Vec {
	@:generic @:noUsing
	public static inline function create<T>(length:Int, factory:(index:Int) -> T):haxe.ds.Vector<T> {
		final vec = new haxe.ds.Vector<T>(length);
		for (i in 0...length)
			vec[i] = factory(i);
		return vec;
	}
}
