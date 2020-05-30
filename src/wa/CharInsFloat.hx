package wa;

import wa.CharIn;
import wa.Vec;
import wa.Floats;

/**
	Utility static functions for `CharIn` related to `Float` type.
**/
class CharInsFloat {
	/**
		Reads a `Float` value separated by any whitespace character (SP, HL, CR or LF).
	**/
	public static inline function float(cin:CharIn):Float
		return Floats.atof(cin.str());

	/**
		Reads a sequence of `Float` values separated by any whitespace characters (SP, HL, CR or LF).
		@see `strVec()` for notes.
	**/
	public static inline function floatVec(cin:CharIn, length:Int):Vec<Float> {
		final vec = new Vec<Float>(length);
		for (i in 0...length)
			vec[i] = float(cin);
		return vec;
	}
}
