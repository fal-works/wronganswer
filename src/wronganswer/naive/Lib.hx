package wronganswer.naive;

/**
	wronganswer / CC0
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
		Reads until the next CR and/or LF.
	**/
	public inline function line()
		return this.readLine();

	/**
		Reads until the next CR and/or LF, then trims and splits the result.
		@param delimiter Defaults to a space.
	**/
	public inline function lineSplit(delimiter:String = " ")
		return StringTools.trim(line()).split(delimiter);

	/**
		Reads until the next CR and/or LF, then trims and splits the result
		and maps it to `Array<Int>`.
		@param delimiter Defaults to a space.
	**/
	public inline function lineSplitInt(?delimiter:String)
		return lineSplit(delimiter).map(Ut.atoi);
}

/**
	Utility static functions.
**/
class Ut {
	/**
		Prints a debug log.
		Has no effect on Java/JS targets.
	**/
	public static macro function debug(message:haxe.macro.Expr):haxe.macro.Expr {
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

	/**
		Converts `s` to `Float`.
	**/
	@:pure public static inline function atof(s:String):Float {
		final f = Std.parseFloat(s);
		#if debug
		if (!Math.isFinite(f))
			throw 'Failed to parse: $s';
		#end
		return f;
	}

	/**
		Converts `characterCode` to `String`.
	**/
	@:pure public static inline function itoa(characterCode:Int):String
		return String.fromCharCode(characterCode);
}
