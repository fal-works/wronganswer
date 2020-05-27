package wronganswer.naive;

import wronganswer.naive.Delimiter;

abstract CharIn(haxe.io.Input) {
	public extern inline function new()
		this = Sys.stdin();

	public inline function byte()
		return this.readByte();

	public inline function digit()
		return byte() - "0".code;

	public inline function char()
		return String.fromCharCode(byte());

	public inline function str(delimiter:Int) {
		final buffer = new haxe.io.BytesBuffer();
		try {
			var byte:Int;
			while ((byte = this.readByte()) != delimiter)
				buffer.addByte(byte);
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}

	public inline function int(delimiter:Int):Int
		return Std.parseInt(str(delimiter));
}
