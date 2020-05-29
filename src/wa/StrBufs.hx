package wa;

import wa.Char;
import wa.StrBuf;
import wa.Floats;

/**
	Utility static functions for `StrBuf` type.
**/
class StrBufs {
	/**
		Appends an `Int64` value.
	**/
	public static inline function int64(buf:StrBuf, v:haxe.Int64):StrBuf
		return @:privateAccess buf.addDynamic(Std.string(v));

	/**
		Appends a `Float` value.
	**/
	public static inline function float(buf:StrBuf, v:Float):StrBuf
		return @:privateAccess buf.addDynamic(v);

	/**
		Appends `v` to `buf` formatted with `scale`.
		@param scale The number of fractional digits.
	**/
	public static inline function floatWithScale(buf:StrBuf, v:Float, scale:Int):StrBuf
		return buf.str(Floats.ftoa(v, scale));

	/**
		Appends all values from `vec`.
	**/
	public static inline function int64Vec(buf:StrBuf, vec:haxe.ds.Vector<haxe.Int64>, separator:Char):StrBuf {
		int64(buf, vec[0]);
		for (i in 1...vec.length) {
			buf.char(separator);
			int64(buf, vec[i]);
		}
		return buf;
	}

	/**
		Appends all values from `vec`.
	**/
	public static inline function floatVec(buf:StrBuf, vec:haxe.ds.Vector<Float>, separator:Char):StrBuf {
		float(buf, vec[0]);
		for (i in 1...vec.length) {
			buf.char(separator);
			float(buf, vec[i]);
		}
		return buf;
	}

	/**
		Appends all values from `vec` formatted with `scale`.
	**/
	public static inline function floatVecWithScale(buf:StrBuf, vec:haxe.ds.Vector<Float>, scale:Int, separator:Char):StrBuf {
		floatWithScale(buf, vec[0], scale);
		for (i in 1...vec.length) {
			buf.char(separator);
			floatWithScale(buf, vec[i], scale);
		}
		return buf;
	}
}
