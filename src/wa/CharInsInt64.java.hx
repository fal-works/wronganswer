package wa;

import wa.CharIn;
import wa.Char32;
import wa.Vec;
import wa.Int64;

class CharInsInt64 {
	public static inline function int64(cin:CharIn):Int64 {
		var result:Int64 = 0;
		var negative = false;
		try {
			var character = cin.char();
			if (character == "-".code) {
				negative = true;
				character = cin.char();
			}
			while (character.isNotWhiteSpace()) {
				final digit = character.toDigit();
				#if debug
				if (digit < 0 || 10 <= digit)
					throw "Failed to parse.";
				#end
				result = 10 * result + digit;
				character = cin.char();
			}
		} catch (e:haxe.io.Eof) {}

		return if (negative) -result else result;
	}

	public static inline function uint64(cin:CharIn):Int64
		return uint64WithRadix(cin, 10);

	public static inline function int64Vec(cin:CharIn, length:Int):Vec<Int64> {
		final vec = new Vec<Int64>(length);
		for (i in 0...length)
			vec[i] = int64(cin);
		return vec;
	}

	public static inline function uint64Vec(cin:CharIn, length:Int):Vec<Int64> {
		final vec = new Vec<Int64>(length);
		for (i in 0...length)
			vec[i] = uint64(cin);
		return vec;
	}

	static inline function uint64WithRadix(cin:CharIn, radix:Int64):Int64 {
		var result:Int64 = 0;
		try {
			var character:Char32;
			while ((character = cin.char()).isNotWhiteSpace())
				result = radix * result + character.toDigit();
		} catch (e:haxe.io.Eof) {}

		return result;
	}
}
