package wa;

@:forward(length, toString)
abstract StrBuf(#if macro Dynamic #else java.lang.StringBuilder #end)
#if !macro from java.lang.StringBuilder
#end
{
	public inline function new(capacity = 16) {
		this = #if macro null; #else new java.lang.StringBuilder(capacity); #end
	}

	public inline function str(s:String):StrBuf
		return this.append(s);

	public inline function int(v:Int):StrBuf
		return this.append(v);

	public inline function float(v:Float):StrBuf
		return this.append(v);

	public inline function int64(v:haxe.Int64):StrBuf
		return this.append(v);

	public inline function char(code:Int):StrBuf
		return this.appendCodePoint(code);

	public inline function lf():StrBuf
		return char("\n".code);

	public inline function space():StrBuf
		return char(" ".code);
}
