package wa.naive;

abstract CharIn(haxe.io.Input) {
	public extern inline function new()
		this = Sys.stdin();

	public inline function byte()
		return this.readByte();

	public inline function char():Char
		return byte();

	public inline function str(delimiter:Char) {
		final buffer = new haxe.io.BytesBuffer();
		try {
			var character:Char;
			while ((character = char()) != delimiter)
				buffer.addByte(character);
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}

	public inline function int(delimiter:Char):Int
		return Std.parseInt(str(delimiter));
}
