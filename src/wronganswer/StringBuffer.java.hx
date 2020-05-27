package wronganswer;

@:forward(length, toString)
abstract StringBuffer(#if macro Dynamic #else java.lang.StringBuilder #end)
#if !macro from java.lang.StringBuilder
#end
{
	public inline function new(capacity = 16) {
		this = #if macro null; #else new java.lang.StringBuilder(capacity); #end
	}

	public inline function str(s:String):StringBuffer
		return this.append(s);

	public inline function int(v:Int):StringBuffer
		return this.append(v);

	public inline function float(v:Float):StringBuffer
		return this.append(v);

	public inline function floatWithScale(v:Float, scale:Int):StringBuffer {
		if (v < 0) {
			this.appendCodePoint("-".code);
			v = -v;
		}
		v += Math.pow(10.0, -scale) / 2.0;

		this.append(cast(v, haxe.Int64));
		if (scale != 0) {
			this.appendCodePoint(".".code);
			v -= cast(cast(v, haxe.Int64), Float);

			for (i in 0...scale) {
				v *= 10.0;
				this.append(((cast v) : Int));
				v -= Std.int(v);
			}
		}

		return this;
	}

	public inline function int64(v:haxe.Int64):StringBuffer
		return this.append(v);

	public inline function char(code:Int):StringBuffer
		return this.appendCodePoint(code);

	public inline function lf():StringBuffer
		return char("\n".code);

	public inline function space():StringBuffer
		return char(" ".code);
}
