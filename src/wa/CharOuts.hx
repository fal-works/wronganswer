package wa;

import wa.StrBufs;

/**
	Utility static functions for `CharOuts` type.
**/
class CharOuts {
	/**
		Appends an `Int64` value.
	**/
	public static inline function int64(buf:CharOut, v:haxe.Int64):CharOut
		return StrBufs.int64(buf, v);

	/**
		Appends a `Float` value.
	**/
	public static inline function float(buf:CharOut, v:Float):CharOut
		return StrBufs.float(buf, v);

	/**
		Appends `v` to `buf` formatted with `scale`.
		@param scale The number of fractional digits.
	**/
	public static inline function floatWithScale(buf:CharOut, v:Float, scale:Int):CharOut
		return StrBufs.floatWithScale(buf, v, scale);

	/**
		Appends all values from `vec`.
		Note that nothing will be appended at the end.
	**/
	public static inline function int64Vec(buf:CharOut, vec:haxe.ds.Vector<haxe.Int64>, separator:Char):CharOut
		return StrBufs.int64Vec(buf, vec, separator);

	/**
		Appends all values from `vec`.
		Note that nothing will be appended at the end.
	**/
	public static inline function floatVec(buf:CharOut, vec:haxe.ds.Vector<Float>, separator:Char):CharOut
		return StrBufs.floatVec(buf, vec, separator);

	/**
		Appends all values from `vec` formatted with `scale`.
		Note that nothing will be appended at the end.
	**/
	public static inline function floatVecWithScale(buf:CharOut, vec:haxe.ds.Vector<Float>, scale:Int, separator:Char):CharOut
		return StrBufs.floatVecWithScale(buf, vec, scale, separator);
}
