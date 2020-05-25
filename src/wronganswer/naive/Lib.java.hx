package wronganswer.naive;

/**
	wronganswer (naive) / CC0
	https://github.com/fal-works/wronganswer
**/

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
			while ((byte = this.readByte()) != delimiter) {
				buffer.addByte(byte);
			}
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}

	public inline function int(delimiter:Int):Int
		return Ut.atoi(str(delimiter));
}

enum abstract Delimiter(Int) to Int {
	final LF = "\n".code;
	final SP = " ".code;
}

class Ut {
	@:noUsing public static macro function debug(message:haxe.macro.Expr):haxe.macro.Expr
		return macro null;

	@:pure public static inline function atoi(s:String):Int
		return Std.parseInt(s);
}
