package wronganswer.naive;

/**
	wronganswer (naive) / CC0
	https://github.com/fal-works/wronganswer
**/

abstract CharIn(#if macro Null<Dynamic> #else js.node.buffer.Buffer #end) {
	public extern inline function new()
		this = #if macro cast null; #else js.node.Buffer.alloc(1); #end

	public inline function byte() {
		#if !macro
		js.node.Fs.readSync(0, this, 0, 1, null);
		#end
		return this[0];
	}

	public inline function digit()
		return byte() - "0".code;

	public inline function char()
		return String.fromCharCode(byte());

	public inline function str(delimiter:Int) {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		while (byte != delimiter) {
			result += String.fromCharCode(byte);
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			byte = this[0];
		}
		#end
		return result;
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
