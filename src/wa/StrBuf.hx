package wa;

import wa.Char;

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
		Appends an ASCII character.
	**/
	public inline function char(characterCode:Char):StrBuf {
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

	/**
		Appends all values from `vec`.
		Note that nothing will be appended at the end.
	**/
	public inline function strVec(vec:haxe.ds.Vector<String>, separator:Char):StrBuf {
		str(vec[0]);
		for (i in 1...vec.length) {
			char(separator);
			str(vec[i]);
		}
		return this;
	}

	/**
		Appends all values from `vec`.
		Note that nothing will be appended at the end.
	**/
	public inline function intVec(vec:haxe.ds.Vector<Int>, separator:Char):StrBuf {
		int(vec[0]);
		for (i in 1...vec.length) {
			char(separator);
			int(vec[i]);
		}
		return this;
	}

	inline function addDynamic(v:Dynamic):StrBuf {
		this.add(v);
		return this;
	}
}
