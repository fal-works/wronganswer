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
		Reads 1 decimal digit.
	**/
	public inline function digit()
		return byte() - "0".code;

	/**
		Reads 1 ASCII character.
	**/
	public inline function char()
		return String.fromCharCode(byte());

	/**
		Reads until `delimiter`.
	**/
	public inline function str(delimiter:Int) {
		final buffer = new haxe.io.BytesBuffer();
		try {
			var byte:Int;
			while ((byte = this.readByte()) != delimiter)
				buffer.addByte(byte);
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}

	/**
		Reads an `Int` value until `delimiter`.
	**/
	public inline function int(delimiter:Int):Int
		return Std.parseInt(str(delimiter));
}
