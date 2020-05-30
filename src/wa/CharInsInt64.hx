package wa;

import wa.CharIn;
import wa.Char32;
import wa.Vec;
import wa.Int64;

/**
	Utility static functions for `CharIn` related to `Int64` type.
**/
class CharInsInt64 {
	/**
		Reads an `Int64` value separated by any whitespace character (SP, HL, CR or LF).
	**/
	public static inline function int64(cin:CharIn):Int64 {
		var result:Int64 = 0;
		var negative = false;
		try {
			var character = cin.char();
			if (character == '-'.code) {
				negative = true;
				character = cin.char();
			}
			while (character.isNotWhiteSpace()) {
				result = 10 * result + character.toDigit();
				character = cin.char();
			}
		} catch (e:haxe.io.Eof) {}

		return if (negative) -result else result;
	}

	/**
		Reads an `Int64` value (assuming unsigned)
		separated by any whitespace character (SP, HL, CR or LF).
	**/
	public static inline function uint64(cin:CharIn):Int64
		return uint64WithRadix(cin, 10);

	/**
		Reads a sequence of `Int64` values separated by any whitespace characters (SP, HL, CR or LF).
		@see `strVec()` for notes.
	**/
	public static inline function int64Vec(cin:CharIn, length:Int):Vec<Int64> {
		final vec = new Vec<Int64>(length);
		for (i in 0...length)
			vec[i] = int64(cin);
		return vec;
	}

	/**
		Reads a sequence of `Int64` values (assuming unsigned)
		separated by any whitespace characters (SP, HL, CR or LF).
		@see `strVec()` for notes.
	**/
	public static inline function uint64Vec(cin:CharIn, length:Int):Vec<Int64> {
		final vec = new Vec<Int64>(length);
		for (i in 0...length)
			vec[i] = uint64(cin);
		return vec;
	}

	/**
		Reads an unsigned number and returns as `Int64`.
		Alphabets must be in lower case.
	**/
	static inline function uint64WithRadix(cin:CharIn, radix:Int64):Int64 {
		var result:Int64 = 0;
		try {
			var character:Char32;
			while ((character = cin.char()).isNotWhiteSpace()) {
				final digit = character.toDigit();
				#if debug
				if (digit < 0 || radix <= digit)
					throw "Failed to parse.";
				#end
				result = radix * result + digit;
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}
}
