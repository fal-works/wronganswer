package wa;

import wa.Int64;

class Int64s {
	@:pure @:noUsing public static inline function min(a:Int64, b:Int64):Int64
		return if (a < b) a else b;

	@:pure @:noUsing public static inline function max(a:Int64, b:Int64):Int64
		return if (a < b) b else a;

	@:pure public static inline function div(n:Int64, divisor:Int64):Int64
		return #if macro 0; #else untyped __java__("{0} / {1}", n, divisor); #end

	@:pure public static inline function abs(n:Int64):Int64 {
		return (n ^ (n >> 63)) - (n >> 63);
	}

	@:pure public static inline function isEven(n:Int64):Bool {
		return n & 1 == 0;
	}

	@:pure public static inline function isOdd(n:Int64):Bool {
		return n & 1 == 1;
	}
}
