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
		final buffer = new haxe.io.BytesBuffer();
		try {
			var character:Char32;
			while ((character = cin.char()) != delimiter)
				buffer.addByte(cast character);
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}
}
