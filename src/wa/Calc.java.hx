package wa;

class Calc {
	@:pure @:noUsing public static inline function imin(a:Int, b:Int):Int
		return if (a < b) a else b;

	@:pure @:noUsing public static inline function imax(a:Int, b:Int):Int
		return if (a < b) b else a;

	@:pure public static inline function idiv(n:Int, divisor:Int):Int
		return #if macro 0; #else untyped __java__("{0} / {1}", n, divisor); #end
}
