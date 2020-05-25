package wronganswer.naive;

/**
	wronganswer (naive) / CC0
	https://github.com/fal-works/wronganswer
**/

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
			while ((byte = this.readByte()) != delimiter) {
				buffer.addByte(byte);
			}
		} catch (e:haxe.io.Eof) {}

		return buffer.getBytes().toString();
	}

	/**
		Reads an `Int` value until `delimiter`.
	**/
	public inline function int(delimiter:Int):Int
		return Ut.atoi(str(delimiter));
}

/**
	Character codes used as string delimiters.
**/
enum abstract Delimiter(Int) to Int {
	final LF = "\n".code;
	final SP = " ".code;
}

/**
	Utility static functions.
**/
class Ut {
	/**
		Prints a debug log `#if debug`.
		Has no effect on Java/JS targets.
	**/
	@:noUsing public static macro function debug(message:haxe.macro.Expr):haxe.macro.Expr {
		#if debug
		return macro Sys.println('[DEBUG] ' + Std.string($message));
		#else
		return macro null;
		#end
	}

	/**
		Converts `s` to `Int`.
	**/
	@:pure public static inline function atoi(s:String):Int {
		final i = Std.parseInt(s);
		#if debug
		if (i == null)
			throw 'Failed to parse: $s';
		#end
		return i;
	}
}
