package wronganswer;

@:forward(length, toString)
abstract StringBuffer(StringBuf) from StringBuf {
	public inline function new(?capacity) {
		this = new StringBuf();
	}

	public inline function str(s:String):StringBuffer
		return addDynamic(s);

	public inline function int(v:Int):StringBuffer
		return addDynamic(v);

	public inline function float(v:Float):StringBuffer
		return addDynamic(v);

	public inline function floatWithScale(v:Float, scale:Int):StringBuffer
		return addDynamic(Util.ftoa(v, scale));

	public inline function int64(v:haxe.Int64):StringBuffer
		return addDynamic(Std.string(v));

	public inline function char(code:Int):StringBuffer {
		this.addChar(code);
		return this;
	}

	public inline function lf():StringBuffer
		return char("\n".code);

	public inline function space():StringBuffer
		return char(" ".code);

	inline function addDynamic(v:Dynamic):StringBuffer {
		this.add(v);
		return this;
	}
}
