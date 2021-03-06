package wa;

import wa.CharOut;
import wa.StrBufs;
import wa.Char16;
import wa.Vec;
import wa.Int64;

/**
	Utility static functions for `CharOuts` type.
**/
class CharOuts {
	/**
		Appends an `Int64` value.
	**/
	public static inline function int64(cout:CharOut, v:Int64):CharOut
		return StrBufs.int64(cout, v);

	/**
		Appends a `Float` value.
	**/
	public static inline function float(cout:CharOut, v:Float):CharOut
		return StrBufs.float(cout, v);

	/**
		Appends `v` to `cout` formatted with `scale`.
		@param scale The number of fractional digits.
	**/
	public static inline function floatWithScale(cout:CharOut, v:Float, scale:Int):CharOut
		return StrBufs.floatWithScale(cout, v, scale);

	/**
		Appends all values from `vec`.
		Note that nothing will be appended at the end.
	**/
	public static inline function int64Vec(cout:CharOut, vec:Vec<Int64>, separator:Char16):CharOut
		return StrBufs.int64Vec(cout, vec, separator);

	/**
		Appends all values from `vec`.
		Note that nothing will be appended at the end.
	**/
	public static inline function floatVec(cout:CharOut, vec:Vec<Float>, separator:Char16):CharOut
		return StrBufs.floatVec(cout, vec, separator);

	/**
		Appends all values from `vec` formatted with `scale`.
		Note that nothing will be appended at the end.
	**/
	public static inline function floatVecWithScale(cout:CharOut, vec:Vec<Float>, scale:Int, separator:Char16):CharOut
		return StrBufs.floatVecWithScale(cout, vec, scale, separator);
}
