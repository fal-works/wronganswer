package wronganswer.naive;

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
	**/
	public inline function lineSplit(delimiter:String = " ")
		return StringTools.trim(line()).split(delimiter);

	/**
		Reads until the next CR and/or LF, then trims and splits the result
		and maps it to `Array<Int>`.
	**/
	public inline function lineSplitInt(?delimiter:String)
		return lineSplit(delimiter).map(Statics.atoi);
}

/**
	Utility static functions.
**/
class Statics {
	/**
		Converts `s` to `Int`.
	**/
	@:pure public static inline function atoi(s:String):Int {
		final i = Std.parseInt(s);
		if (i == null) throw 'Failed to parse: $s';
		return i;
	}

	/**
		Converts `s` to `Float`.
	**/
	@:pure public static inline function atof(s:String):Float {
		final f = Std.parseFloat(s);
		if (!Math.isFinite(f)) throw 'Failed to parse: $s';
		return f;
	}

	/**
		Converts `characterCode` to `String`.
	**/
	@:pure public static inline function itoa(characterCode:Int):String
		return String.fromCharCode(characterCode);
}
