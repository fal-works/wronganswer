package wa;

import wa.Int64;

/**
	Utility static functions for `Int64`.
**/
class Int64s {
	/**
		@return The smaller value of `a` and `b`.
	**/
	@:pure @:noUsing public static inline function min(a:Int64, b:Int64):Int64
		return if (a < b) a else b;

	/**
		@return The larger value of `a` and `b`.
	**/
	@:pure @:noUsing public static inline function max(a:Int64, b:Int64):Int64
		return if (a < b) b else a;

	/**
		Performs integer division.
	**/
	@:pure public static inline function div(n:Int64, divisor:Int64):Int64
		return n / divisor;

	/**
		@return Absolute value of `n`.
	**/
	@:pure public static inline function abs(n:Int64):Int64 {
		return (n ^ (n >> 63)) - (n >> 63);
	}

	/**
		@return `true` if `n` is even.
	**/
	@:pure public static inline function isEven(n:Int64):Bool {
		return n & 1 == 0;
	}

	/**
		@return `true` if `n` is odd.
	**/
	@:pure public static inline function isOdd(n:Int64):Bool {
		return n & 1 == 1;
	}
}
