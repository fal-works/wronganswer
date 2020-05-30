package wa;

import wa.CharIn;
import wa.Char32;
import wa.Vec;
import wa.Int64;

class CharIns {
	public static inline function int64(cin:CharIn):Int64 {
		@:privateAccess final buffer = cin.buffer();
		var result:Int64 = 0;
		var negative = false;
		#if !macro
		final readSync = js.node.Fs.readSync;
		try {
			readSync(0, buffer, 0, 1, null);
			var character:Char32 = buffer[0];
			if (character == "-".code) {
				negative = true;
				readSync(0, buffer, 0, 1, null);
				character = buffer[0];
			}
			while (character.isNotWhiteSpace()) {
				result = 10 * result + character.toDigit();
				if (readSync(0, buffer, 0, 1, null) == 0)
					break;
				character = buffer[0];
			}
		} catch (e:Dynamic) {}
		#end

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
		@:privateAccess final buffer = cin.buffer();
		var result:Int64 = 0;
		#if !macro
		final readSync = js.node.Fs.readSync;
		try {
			readSync(0, buffer, 0, 1, null);
			var character:Char32 = buffer[0];
			while (character.isNotWhiteSpace()) {
				result = radix * result + character.toDigit();
				if (readSync(0, buffer, 0, 1, null) == 0)
					break;
				character = buffer[0];
			}
		} catch (e:Dynamic) {}
		#end

		return result;
	}
}
