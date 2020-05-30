package wa;

import wa.CharIn;
import wa.Char32;
import wa.Bits;

class CharIns {
	public static inline function bits(cin:CharIn):Bits
		return @:privateAccess cin.uintWithRadix(2);

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
}
