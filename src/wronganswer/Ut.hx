package wronganswer;

/**
	Utility static functions.
**/
class Ut {
	/**
		Prints `x`.
	**/
	@:generic public static inline function print<T>(x:T):Void
		Sys.print(x);

	/**
		Prints `x` with line break.
	**/
	@:generic public static inline function println<T>(x:T):Void
		Sys.println(x);

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
		Converts `v` to `String`.
		@param scale The number of fractional digits.
	**/
	@:pure public static inline function ftoa(v:Float, scale:Int):String {
		var result = if (v >= 0) "" else {
			v = -v;
			"-";
		};

		v += Math.pow(10.0, -scale) / 2.0;
		final integerPart = Math.ffloor(v);

		if (scale != 0) {
			result += integerPart + ".";
			v -= integerPart;

			for (i in 0...scale) {
				v *= 10.0;
				result += Std.int(v);
				v -= Std.int(v);
			}
		}

		return result;
	}

	/**
		Compares two strings in dictionary order.
		@return Negative if `a` comes before `b`. `0` if equal.
	**/
	@:pure public static inline function compareString(a:String, b:String):Int
		return if (a < b) -1 else if (a > b) 1 else 0;
}
