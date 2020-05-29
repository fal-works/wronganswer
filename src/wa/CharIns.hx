package wa;

import wa.CharIn;
import wa.Char32;
import wa.Floats;

/**
	Utility static functions for `CharIn`.
**/
class CharIns {
	/**
		Reads a `Float` value separated by any whitespace character (SP, HL, CR or LF).
	**/
	public static inline function float(cin:CharIn):Float
		return Floats.atof(cin.str());

	/**
		Reads all data as `String`.
	**/
	public static inline function all(cin:CharIn):String
		return @:privateAccess cin.internal().readAll().toString();

	/**
		Reads until `delimiter`.
	**/
	public static inline function until(cin:CharIn, delimiter:Char32):String {
		var result = "";
		try {
			var character:Char32;
			while ((character = cin.char()) != delimiter)
				result += character.toString();
		} catch (e:haxe.io.Eof) {}

		return result;
	}

	/**
		Reads a sequence of `Float` values separated by any whitespace characters (SP, HL, CR or LF).
		@see `strVec()` for notes.
	**/
	public static inline function floatVec(cin:CharIn, length:Int):haxe.ds.Vector<Float> {
		final vec = new haxe.ds.Vector<Float>(length);
		for (i in 0...length)
			vec[i] = float(cin);
		return vec;
	}

	/**
		Reads a string separated by any whitespace character (SP, HL, CR or LF)
		and counts the number of `characterToCount`.
	**/
	public static inline function count(cin:CharIn, characterToCount:Char32):Int {
		var foundCount = 0;
		try {
			var character = cin.char();
			while (character.isNotWhiteSpace()) {
				if (character == characterToCount)
					++foundCount;

				character = cin.char();
			}
		} catch (e:haxe.io.Eof) {}

		return foundCount;
	}
}
