package wa;

import wa.Char;

@:forward(length, toString)
abstract StrBuf(#if macro Dynamic #else java.lang.StringBuilder #end)
#if !macro from java.lang.StringBuilder
#end
{
	public inline function new(capacity = 16) {
		this = #if macro null; #else new java.lang.StringBuilder(capacity); #end
	}

	public inline function str(s:String):StrBuf
		return #if macro this; #else untyped __java__("{0}.append({1})", this, s); #end

	public inline function int(v:Int):StrBuf
		return this.append(v);

	public inline function char(code:Char):StrBuf
		return this.appendCodePoint(code);

	public inline function lf():StrBuf
		return char("\n".code);

	public inline function space():StrBuf
		return char(" ".code);

	public inline function strVec(vec:haxe.ds.Vector<String>, separator:Char):StrBuf {
		str(vec[0]);
		for (i in 1...vec.length) {
			char(separator);
			str(vec[i]);
		}
		return this;
	}

	public inline function intVec(vec:haxe.ds.Vector<Int>, separator:Char):StrBuf {
		int(vec[0]);
		for (i in 1...vec.length) {
			char(separator);
			int(vec[i]);
		}
		return this;
	}

	inline function builder()
		return this;
}
