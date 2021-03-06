package wa.naive;

import wa.Char32;

/**
	Character input.
**/
abstract CharIn(haxe.io.Input) {
	public extern inline function new()
		this = Sys.stdin();

	/**
		Reads 1 byte ASCII character.
	**/
	public inline function char():Char32
		return this.readByte();

	/**
		Reads a string separated by any whitespace character (SP, HL, CR or LF).
	**/
	public inline function str() {
		final buffer = new haxe.io.BytesBuffer();
		try {
			var character:Char32;
			while ((character = char()).isNotWhiteSpace())
				buffer.addByte(cast character);
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}

	/**
		Reads an `Int` value separated by any whitespace character (SP, HL, CR or LF).
	**/
	public inline function int():Int
		return Std.parseInt(str());
}
