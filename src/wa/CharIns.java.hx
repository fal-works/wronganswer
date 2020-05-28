package wa;

import wa.CharIn;
import wa.Char;
import wa.Floats;

class CharIns {
	public static inline function float(cin:CharIn):Float
		return Floats.atof(cin.str());

	public static inline function until(cin:CharIn, delimiter:Char):String {
		@:privateAccess final byteArray = CharIn.byteArray;
		var index = 0;

		try {
			var character = cin.char();
			while (character != delimiter) {
				byteArray[index] = character;
				++index;
				character = cin.char();
			}
		} catch (e:haxe.io.Eof) {}

		try {
			return #if macro ""; #else new String(byteArray, 0, index, "UTF-8"); #end
		} catch (e:Dynamic) {
			throw e;
		}
	}

	public static inline function floatVec(cin:CharIn, length:Int):haxe.ds.Vector<Float> {
		final vec = new haxe.ds.Vector<Float>(length);
		for (i in 0...length)
			vec[i] = float(cin);
		return vec;
	}

	public static inline function count(cin:CharIn, characterToCount:Char):Int {
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
