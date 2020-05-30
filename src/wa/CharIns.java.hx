package wa;

import wa.CharIn;
import wa.Char32;
import wa.Int64;
import wa.Bits;
import wa.Floats;

class CharIns {
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

	/**
		Reads an `Int64` value (assuming unsigned)
		separated by any whitespace character (SP, HL, CR or LF).
	**/
	public static inline function uint64(cin:CharIn):Int64
		return uint64WithRadix(cin, 10);

	public static inline function bits(cin:CharIn):Bits
		return @:privateAccess cin.uintWithRadix(2);

	public static inline function float(cin:CharIn):Float
		return Floats.atof(cin.str());

	public static inline function all(cin:CharIn):String {
		@:privateAccess final byteArray = CharIn.byteArray;
		var index = 0;

		try {
			var character:Char32;
			while (true) {
				character = cin.char();
				byteArray[index++] = character;
			}
		} catch (e:haxe.io.Eof) {}

		try {
			return #if macro ""; #else new String(byteArray, 0, index, "UTF-8"); #end
		} catch (e:Dynamic) {
			throw e;
		}
	}

	public static inline function until(cin:CharIn, delimiter:Char32):String {
		@:privateAccess final byteArray = CharIn.byteArray;
		var index = 0;

		try {
			var character:Char32;
			while ((character = cin.char()) != delimiter)
				byteArray[index++] = character;
		} catch (e:haxe.io.Eof) {}

		try {
			return #if macro ""; #else new String(byteArray, 0, index, "UTF-8"); #end
		} catch (e:Dynamic) {
			throw e;
		}
	}

	public static inline function int64Vec(cin:CharIn, length:Int):haxe.ds.Vector<Int64> {
		final vec = new haxe.ds.Vector<Int64>(length);
		for (i in 0...length)
			vec[i] = int64(cin);
		return vec;
	}

	public static inline function uint64Vec(cin:CharIn, length:Int):haxe.ds.Vector<Int64> {
		final vec = new haxe.ds.Vector<Int64>(length);
		for (i in 0...length)
			vec[i] = uint64(cin);
		return vec;
	}

	public static inline function floatVec(cin:CharIn, length:Int):haxe.ds.Vector<Float> {
		final vec = new haxe.ds.Vector<Float>(length);
		for (i in 0...length)
			vec[i] = float(cin);
		return vec;
	}

	public static inline function count(cin:CharIn, characterToCount:Char32):Int {
		var foundCount = 0;
		try {
			var character:Char32;
			while ((character = cin.char()).isNotWhiteSpace()) {
				if (character == characterToCount)
					++foundCount;
			}
		} catch (e:haxe.io.Eof) {}

		return foundCount;
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
