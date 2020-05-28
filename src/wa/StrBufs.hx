package wa;

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
		@param separator Character code to be inserted between elements.
		@param delimiterString String to be appended at the end.
	**/
	public static inline function int64Vec(buf:StrBuf, vec:haxe.ds.Vector<haxe.Int64>, separator:Int, delimiterString:String):StrBuf {
		int64(buf, vec[0]);
		for (i in 1...vec.length) {
			buf.char(separator);
			int64(buf, vec[i]);
		}
		buf.str(delimiterString);
		return buf;
	}

	/**
		Appends all values from `vec`.
		@param separator Character code to be inserted between elements.
		@param delimiterString String to be appended at the end.
	**/
	public static inline function floatVec(buf:StrBuf, vec:haxe.ds.Vector<Float>, separator:Int, delimiterString:String):StrBuf {
		float(buf, vec[0]);
		for (i in 1...vec.length) {
			buf.char(separator);
			float(buf, vec[i]);
		}
		buf.str(delimiterString);
		return buf;
	}

	/**
		Appends all values from `vec` formatted with `scale`.
		@param separator Character code to be inserted between elements.
		@param delimiterString String to be appended at the end.
	**/
	public static inline function floatVecWithScale(buf:StrBuf, vec:haxe.ds.Vector<Float>, scale:Int, separator:Int, delimiterString:String):StrBuf {
		floatWithScale(buf, vec[0], scale);
		for (i in 1...vec.length) {
			buf.char(separator);
			floatWithScale(buf, vec[i], scale);
		}
		buf.str(delimiterString);
		return buf;
	}
}
