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
		final buffer = new haxe.io.BytesBuffer();
		try {
			var character:Char;
			while ((character = cin.char()) != delimiter)
				buffer.addByte(cast character);
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}
}
