package wa;

import wa.StrBuf;
import wa.Floats;

/**
	Utility static functions for `StrBuf` type.
**/
class StrBufs {
	/**
		Appends `v` to `buf` formatted with `scale`.
		@param scale The number of fractional digits.
	**/
	public static inline function floatWithScale(buf:StrBuf, v:Float, scale:Int):StrBuf
		return buf.str(Floats.ftoa(v, scale));
}
