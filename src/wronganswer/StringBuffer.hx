package wronganswer;

/**
	Buffer object for building `String` by appending small elements.
**/
@:forward(length, toString)
abstract StringBuffer(StringBuf) from StringBuf {
	public inline function new(?capacity) {
		this = new StringBuf();
	}

	/**
		Appends a `String` value.
	**/
	public inline function str(s:String):StringBuffer
		return addDynamic(s);

	/**
		Appends an `Int` value.
	**/
	public inline function int(v:Int):StringBuffer
		return addDynamic(v);

	/**
		Appends a `Float` value.
	**/
	public inline function float(v:Float):StringBuffer
		return addDynamic(v);

	/**
		Appends a `Float` value with `scale`.
		@param scale The number of fractional digits.
	**/
	public inline function floatWithScale(v:Float, scale:Int):StringBuffer
		return addDynamic(Util.ftoa(v, scale));

	/**
		Appends an `Int64` value.
	**/
	public inline function int64(v:haxe.Int64):StringBuffer
		return addDynamic(Std.string(v));

	/**
		Appends an ASCII character.
	**/
	public inline function char(characterCode:Int):StringBuffer {
		this.addChar(characterCode);
		return this;
	}

	/**
		Appends an LF.
	**/
	public inline function lf():StringBuffer
		return char("\n".code);

	/**
		Appends a space.
	**/
	public inline function space():StringBuffer
		return char(" ".code);

	inline function addDynamic(v:Dynamic):StringBuffer {
		this.add(v);
		return this;
	}
}
