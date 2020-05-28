package wa;

import wa.CharIn;
import wa.Chars;
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
		Reads until `delimiter`.
	**/
	public static inline function until(cin:CharIn, delimiter:Int):String {
		var result = "";
		try {
			var byte = cin.byte();
			while (byte != delimiter) {
				result += String.fromCharCode(byte);
				byte = cin.byte();
			}
		} catch (e:haxe.io.Eof) {}

		return StringTools.rtrim(result);
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
		and counts the number of `characterCode`.
	**/
	public static inline function count(cin:CharIn, characterCode:Int):Int {
		var foundCount = 0;
		try {
			var byte = cin.byte();
			while (Chars.isNotWhiteSpace(byte)) {
				if (byte == characterCode)
					++foundCount;

				byte = cin.byte();
			}
		} catch (e:haxe.io.Eof) {}

		return foundCount;
	}
}
