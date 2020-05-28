package wa;

import wa.CharIn;
import wa.Char;
import wa.Floats;

class CharIns {
	public static inline function float(cin:CharIn):Float
		return Floats.atof(cin.str());

	public static inline function until(cin:CharIn, delimiter:Char):String {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		@:privateAccess final buffer = cin.buffer();

		readSync(0, buffer, 0, 1, null);
		var character:Char = buffer[0];
		while (character != delimiter) {
			result += character.toString();
			if (readSync(0, buffer, 0, 1, null) == 0)
				break;
			character = buffer[0];
		}
		#end

		return StringTools.rtrim(result);
	}

	public static inline function floatVec(cin:CharIn, length:Int):haxe.ds.Vector<Float> {
		final vec = new haxe.ds.Vector<Float>(length);
		for (i in 0...length)
			vec[i] = float(cin);
		return vec;
	}

	public static inline function count(cin:CharIn, characterToCount:Char):Int {
		var foundCount = 0;
		#if !macro
		final readSync = js.node.Fs.readSync;
		@:privateAccess final buffer = cin.buffer();

		readSync(0, buffer, 0, 1, null);
		var character:Char = buffer[0];
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
