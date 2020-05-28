package wa.naive;

import wa.Char;

/**
	Character input.
**/
abstract CharIn(haxe.io.Input) {
	public extern inline function new()
		this = Sys.stdin();

	/**
		Reads 1 byte ASCII character.
	**/
	public inline function char():Char
		return this.readByte();

	/**
		Reads a string separated by any whitespace character (SP, HL, CR or LF).
	**/
	public inline function str() {
		final buffer = new haxe.io.BytesBuffer();
		try {
			var character:Char;
			while ((character = char()).isNotWhiteSpace())
				buffer.addByte(character);
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}

	/**
		Reads an `Int` value separated by any whitespace character (SP, HL, CR or LF).
	**/
	public inline function int():Int
		return Std.parseInt(str());

	/**
		Reads until `delimiter`.
	**/
	public inline function until(delimiter:Char) {
		final buffer = new haxe.io.BytesBuffer();
		try {
			var character:Char;
			while ((character = char()) != delimiter)
				buffer.addByte(character);
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}
}
