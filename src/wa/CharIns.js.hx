package wa;

import wa.CharIn;
import wa.Char32;
import wa.Floats;

class CharIns {
	public static inline function float(cin:CharIn):Float
		return Floats.atof(cin.str());

	public static inline function all(cin:CharIn):String {
		@:privateAccess final buffer = cin.buffer();
		final size = js.node.Fs.readSync(0, buffer, 0, buffer.length, null);
		return buffer.toString("utf8", 0, size);
	}

	public static inline function until(cin:CharIn, delimiter:Char32):String {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		@:privateAccess final buffer = cin.buffer();

		try {
			readSync(0, buffer, 0, 1, null);
			var character:Char32 = buffer[0];
			while (character != delimiter) {
				result += character.toString();
				if (readSync(0, buffer, 0, 1, null) == 0)
					break;
				character = buffer[0];
			}
		} catch (e:Dynamic) {}
		#end

		return result;
	}

	public static inline function floatVec(cin:CharIn, length:Int):haxe.ds.Vector<Float> {
		final vec = new haxe.ds.Vector<Float>(length);
		for (i in 0...length)
			vec[i] = float(cin);
		return vec;
	}

	public static inline function count(cin:CharIn, characterToCount:Char32):Int {
		var foundCount = 0;
		#if !macro
		final readSync = js.node.Fs.readSync;
		@:privateAccess final buffer = cin.buffer();

		readSync(0, buffer, 0, 1, null);
		var character:Char32 = buffer[0];
		while (character.isNotWhiteSpace()) {
			if (character == characterToCount)
				++foundCount;
			if (readSync(0, buffer, 0, 1, null) == 0)
				break;
			character = buffer[0];
		}
		#end

		return foundCount;
	}
}
