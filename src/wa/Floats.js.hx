package wa;

class Floats {
	@:pure public static inline function ftoa(v:Float, scale:Int):String {
		var result = if (v >= 0) "" else {
			v = -v;
			"-";
		};

		v += Math.pow(10.0, -scale) / 2.0;
		final integerPart = Std.int(v);

		if (scale != 0) {
			result += integerPart + ".";
			v -= integerPart;

			for (i in 0...scale) {
				v *= 10.0;
				final integerPart = Std.int(v);
				result += integerPart;
				v -= integerPart;
			}
		}

		return result;
	}
}
