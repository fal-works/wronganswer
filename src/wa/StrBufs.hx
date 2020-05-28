package wa;

import wa.StrBuf;
import wa.Floats;

/**
	Utility static functions for `StrBuf` type.
**/
class StrBufs {
	/**
		Appends a `Float` value.
	**/
	public static inline function float(buf:StrBuf, v:Float):StrBuf
		return @:privateAccess buf.addDynamic(v);

	/**
		Appends an `Int64` value.
	**/
	public static inline function int64(buf:StrBuf, v:haxe.Int64):StrBuf
		return @:privateAccess buf.addDynamic(Std.string(v));

	/**
		Appends `v` to `buf` formatted with `scale`.
		@param scale The number of fractional digits.
	**/
	public static inline function floatWithScale(buf:StrBuf, v:Float, scale:Int):StrBuf
		return buf.str(Floats.ftoa(v, scale));
}
