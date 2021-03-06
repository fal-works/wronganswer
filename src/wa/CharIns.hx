package wa;

import wa.CharIn;
import wa.Char32;
import wa.Bits;

/**
	Utility static functions for `CharIn`.
**/
class CharIns {
	/**
		Reads a binary integer separated by any whitespace character (SP, HL, CR or LF).
	**/
	public static inline function bits(cin:CharIn):Bits
		return @:privateAccess cin.uintWithRadix(2);

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
