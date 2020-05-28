package wa;

import wa.StrBuf;
using wa.StrBufs;

class Floats {
	/**
		Converts `v` to `String`.
		@param scale The number of fractional digits.
	**/
	@:pure public static inline function ftoa(v:Float, scale:Int):String {
		final buffer = new StrBuf(15 + scale);
		buffer.floatWithScale(v, scale);
		return buffer.toString();
	}
}
