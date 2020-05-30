package wa;

/**
	Utility static functions for `Int`.
**/
class Ints {
	/**
		@return The smaller value of `a` and `b`.
	**/
	@:pure @:noUsing public static inline function min(a:Int, b:Int):Int
		return if (a < b) a else b;

	/**
		@return The larger value of `a` and `b`.
	**/
	@:pure @:noUsing public static inline function max(a:Int, b:Int):Int
		return if (a < b) b else a;

	/**
		Performs integer division.
	**/
	@:pure public static inline function div(n:Int, divisor:Int):Int
		return Std.int(n / divisor);

	/**
		@return Absolute value of `n`.
	**/
	@:pure public static inline function abs(n:Int):Int {
		return (n ^ (n >> 31)) - (n >> 31);
	}
}
