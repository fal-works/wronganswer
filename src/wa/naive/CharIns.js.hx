package wa.naive;

import wa.Char32;
import wa.naive.CharIn;

/**
	Utility static functions for `CharIn`.
**/
class CharIns {
	/**
		Reads until `delimiter`.
	**/
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

		return StringTools.rtrim(result);
	}
}
