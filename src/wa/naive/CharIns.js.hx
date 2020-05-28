package wa.naive;

import wa.Char;
import wa.naive.CharIn;

/**
	Utility static functions for `CharIn`.
**/
class CharIns {
	/**
		Reads until `delimiter`.
	**/
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
}
