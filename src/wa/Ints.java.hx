package wa;

class Ints {
	@:pure @:noUsing public static inline function min(a:Int, b:Int):Int
		return if (a < b) a else b;

	@:pure @:noUsing public static inline function max(a:Int, b:Int):Int
		return if (a < b) b else a;

	@:pure public static inline function div(n:Int, divisor:Int):Int
		return #if macro 0; #else untyped __java__("{0} / {1}", n, divisor); #end

	@:pure public static inline function abs(n:Int):Int {
		return (n ^ (n >> 31)) - (n >> 31);
	}
}
