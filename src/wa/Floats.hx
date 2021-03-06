package wa;

/**
	Utility static functions for `Float` type.
**/
class Floats {
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
}
