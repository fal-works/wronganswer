package wa;

import wa.Char32;
import wa.Vec;

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

	public inline function char(character:Char32):StrBuf
		return this.append(@:privateAccess character.char16());

	public inline function lf():StrBuf
		return char("\n".code);

	public inline function space():StrBuf
		return char(" ".code);

	public inline function strVec(vec:Vec<String>, separator:Char32):StrBuf {
		str(vec[0]);
		for (i in 1...vec.length) {
			char(separator);
			str(vec[i]);
		}
		return this;
	}

	public inline function intVec(vec:Vec<Int>, separator:Char32):StrBuf {
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
