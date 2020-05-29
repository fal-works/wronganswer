package wa;

import wa.CharIn;
import wa.Char32;
import wa.Floats;

class CharIns {
	public static inline function float(cin:CharIn):Float
		return Floats.atof(cin.str());

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
}
