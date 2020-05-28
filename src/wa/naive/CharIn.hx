package wa.naive;

/**
	Character input.
**/
abstract CharIn(haxe.io.Input) {
	public extern inline function new()
		this = Sys.stdin();

	/**
		Reads 1 byte.
	**/
	public inline function byte()
		return this.readByte();

	/**
		Reads 1 ASCII character.
	**/
	public inline function char():Char
		return byte();

	/**
		Reads until `delimiter`.
	**/
	public inline function str(delimiter:Char) {
		final buffer = new haxe.io.BytesBuffer();
		try {
			var character:Char;
			while ((character = char()) != delimiter)
				buffer.addByte(character);
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}

	/**
		Reads an `Int` value until `delimiter`.
	**/
	public inline function int(delimiter:Char):Int
		return Std.parseInt(str(delimiter));
}
