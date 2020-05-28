package wa;

import wa.CharIn;
import wa.Delimiter;
import wa.Floats;

class CharIns {
	public static inline function float(cin:CharIn):Float
		return Floats.atof(cin.str());

	public static inline function until(cin:CharIn, delimiter:Delimiter):String {
		@:privateAccess final byteArray = CharIn.byteArray;
		var index = 0;

		try {
			var byte = cin.byte();
			while (byte != delimiter) {
				byteArray[index] = byte;
				++index;
				byte = cin.byte();
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

	public static inline function count(cin:CharIn, characterCode:Int):Int {
		var foundCount = 0;
		try {
			var byte = cin.byte();
			while (@:privateAccess CharIn.isNotWhiteSpace(byte)) {
				if (byte == characterCode)
					++foundCount;
				byte = cin.byte();
			}
		} catch (e:haxe.io.Eof) {}

		return foundCount;
	}
}
