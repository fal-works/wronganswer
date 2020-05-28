package wa;

@:forward(length, toString)
abstract StrBuf(StringBuf) from StringBuf {
	public inline function new(?capacity) {
		this = new StringBuf();
	}

	public inline function str(s:String):StrBuf
		return addDynamic(s);

	public inline function int(v:Int):StrBuf
		return addDynamic(v);

	public inline function float(v:Float):StrBuf
		return addDynamic(v);

	public inline function int64(v:haxe.Int64):StrBuf
		return addDynamic(Std.string(v));

	public inline function char(code:Int):StrBuf {
		this.addChar(code);
		return this;
	}

	public inline function lf():StrBuf
		return char("\n".code);

	public inline function space():StrBuf
		return char(" ".code);

	inline function addDynamic(v:Dynamic):StrBuf {
		this.add(v);
		return this;
	}
}
