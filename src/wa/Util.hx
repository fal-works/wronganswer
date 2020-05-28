package wa;

/**
	General utility static functions.
**/
class Util {
	/**
		Prints `x`.
		More optimized than `Sys.print()` on java/js targets.
	**/
	@:generic public static inline function print<T>(x:T):Void
		Sys.print(x);

	/**
		Prints `x` with line break.
		More optimized than `Sys.println()` on java/js targets.
	**/
	@:generic public static inline function println<T>(x:T):Void
		Sys.println(x);

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
		Converts `s` to `Int`.
	**/
	@:pure public static inline function atoi(s:String):Int {
		final i = Std.parseInt(s);
		#if debug
		if (i == null)
			throw 'Failed to parse: $s';
		#end
		return i;
	}

	/**
		Converts `s` to `Float`.
	**/
	@:pure public static inline function atof(s:String):Float {
		final f = Std.parseFloat(s);
		#if debug
		if (!Math.isFinite(f))
			throw 'Failed to parse: $s';
		#end
		return f;
	}

	/**
		Converts `characterCode` to `String`.
	**/
	@:pure public static inline function ctoa(characterCode:Int):String
		return String.fromCharCode(characterCode);

	/**
		Compares two strings in dictionary order.
		@return Negative if `a` comes before `b`. `0` if equal.
	**/
	@:pure public static inline function compareString(a:String, b:String):Int
		return if (a < b) -1 else if (b < a) 1 else 0;
}
