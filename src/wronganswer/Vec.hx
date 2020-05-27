package wronganswer;

class Vec {
	/**
		Creates a vector of elements returned from `factory()` callback.

		Note:
		- It first allocates an array with `length` and then assigns values.
		  On JS target there might be some tradeoffs here.
		- On Java target, `Vector` cannot be directly converted to `String`.
	**/
	@:generic @:noUsing
	public static inline function create<T>(length:Int, factory:(index:Int) -> T):haxe.ds.Vector<T> {
		final vec = new haxe.ds.Vector<T>(length);
		for (i in 0...length)
			vec[i] = factory(i);
		return vec;
	}
}
