package wa;

/**
	Buffer object for building `String` by appending small elements.
**/
@:forward(length, toString)
abstract StrBuf(StringBuf) from StringBuf {
	public inline function new(?capacity) {
		this = new StringBuf();
	}

	/**
		Appends a `String` value.
	**/
	public inline function str(s:String):StrBuf
		return addDynamic(s);

	/**
		Appends an `Int` value.
	**/
	public inline function int(v:Int):StrBuf
		return addDynamic(v);

	/**
		Appends a `Float` value.
	**/
	public inline function float(v:Float):StrBuf
		return addDynamic(v);

	/**
		Appends a `Float` value with `scale`.
		@param scale The number of fractional digits.
	**/
	public inline function floatWithScale(v:Float, scale:Int):StrBuf
		return addDynamic(Util.ftoa(v, scale));

	/**
		Appends an `Int64` value.
	**/
	public inline function int64(v:haxe.Int64):StrBuf
		return addDynamic(Std.string(v));

	/**
		Appends an ASCII character.
	**/
	public inline function char(characterCode:Int):StrBuf {
		this.addChar(characterCode);
		return this;
	}

	/**
		Appends an LF.
	**/
	public inline function lf():StrBuf
		return char("\n".code);

	/**
		Appends a space.
	**/
	public inline function space():StrBuf
		return char(" ".code);

	inline function addDynamic(v:Dynamic):StrBuf {
		this.add(v);
		return this;
	}
}
