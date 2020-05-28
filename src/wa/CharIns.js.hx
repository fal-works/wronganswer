package wa;

import wa.CharIn;
import wa.Char;
import wa.Floats;

class CharIns {
	public static inline function float(cin:CharIn):Float
		return Floats.atof(cin.str());

	public static inline function until(cin:CharIn, delimiter:Int):String {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		@:privateAccess final buffer = cin.buffer();

		readSync(0, buffer, 0, 1, null);
		var byte = buffer[0];
		while (byte != delimiter) {
			result += String.fromCharCode(byte);
			if (readSync(0, buffer, 0, 1, null) == 0)
				break;
			byte = buffer[0];
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

	public static inline function count(cin:CharIn, characterCode:Int):Int {
		var foundCount = 0;
		#if !macro
		final readSync = js.node.Fs.readSync;
		@:privateAccess final buffer = cin.buffer();

		readSync(0, buffer, 0, 1, null);
		var byte = buffer[0];
		while (Char.isNotWhiteSpace(byte)) {
			if (byte == characterCode)
				++foundCount;
			if (readSync(0, buffer, 0, 1, null) == 0)
				break;
			byte = buffer[0];
		}
		#end

		return foundCount;
	}
}
