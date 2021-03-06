package wa;

import wa.CharIn;
import wa.Char32;
import wa.Bits;

class CharIns {
	public static inline function bits(cin:CharIn):Bits
		return @:privateAccess cin.uintWithRadix(2);

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
