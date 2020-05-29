package wa;

import wa.StrBufs;

/**
	Utility static functions for `CharOuts` type.
**/
class CharOuts {
	/**
		Appends an `Int64` value.
	**/
	public static inline function int64(cout:CharOut, v:haxe.Int64):CharOut
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
	public static inline function int64Vec(cout:CharOut, vec:haxe.ds.Vector<haxe.Int64>, separator:Char):CharOut
		return StrBufs.int64Vec(cout, vec, separator);

	/**
		Appends all values from `vec`.
		Note that nothing will be appended at the end.
	**/
	public static inline function floatVec(cout:CharOut, vec:haxe.ds.Vector<Float>, separator:Char):CharOut
		return StrBufs.floatVec(cout, vec, separator);

	/**
		Appends all values from `vec` formatted with `scale`.
		Note that nothing will be appended at the end.
	**/
	public static inline function floatVecWithScale(cout:CharOut, vec:haxe.ds.Vector<Float>, scale:Int, separator:Char):CharOut
		return StrBufs.floatVecWithScale(cout, vec, scale, separator);
}
