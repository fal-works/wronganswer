package wa.naive;

import wa.Char;

abstract CharIn(haxe.io.Input) {
	public extern inline function new()
		this = Sys.stdin();

	public inline function char():Char
		return this.readByte();

	public inline function str() {
		final buffer = new haxe.io.BytesBuffer();
		try {
			var character:Char;
			while ((character = char()).isNotWhiteSpace())
				buffer.addByte(character);
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}

	public inline function int():Int
		return Std.parseInt(str());

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
