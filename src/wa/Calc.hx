package wa;

/**
	Math utility functions.
**/
class Calc {
	/**
		@return The smaller value of `a` and `b`.
	**/
	@:pure @:noUsing public static inline function imin(a:Int, b:Int):Int
		return if (a < b) a else b;

	/**
		@return The larger value of `a` and `b`.
	**/
	@:pure @:noUsing public static inline function imax(a:Int, b:Int):Int
		return if (a < b) b else a;

	/**
		Performs integer division.
	**/
	@:pure public static inline function idiv(n:Int, divisor:Int):Int
		return Std.int(n / divisor);

	/**
		@return Absolute value of `n`.
	**/
	@:pure public static inline function iabs(n:Int):Int
		return if (n < 0) -n else n;
}
