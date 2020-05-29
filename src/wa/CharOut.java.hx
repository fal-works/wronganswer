package wa;

abstract CharOut(#if macro Dynamic #else java.io.PrintWriter #end) #if !macro from java.io.PrintWriter #end {
	public inline function new() {
		this = #if macro null; #else new java.io.PrintWriter(java.lang.System.out); #end
	}

	public inline function str(s:String):CharOut {
		#if !macro
		untyped __java__("{0}.print({1})", this, s);
		#end
		return this;
	}

	public inline function int(v:Int):CharOut {
		this.print(v);
		return this;
	}

	public inline function char(character:Char):CharOut {
		#if !macro
		this.append(@:privateAccess character.char16());
		#end
		return this;
	}

	public inline function lf():CharOut
		return char("\n".code);

	public inline function space():CharOut
		return char(" ".code);

	public inline function strVec(vec:haxe.ds.Vector<String>, separator:Char):CharOut {
		str(vec[0]);
		for (i in 1...vec.length) {
			char(separator);
			str(vec[i]);
		}
		return this;
	}

	public inline function intVec(vec:haxe.ds.Vector<Int>, separator:Char):CharOut {
		int(vec[0]);
		for (i in 1...vec.length) {
			char(separator);
			int(vec[i]);
		}
		return this;
	}

	public inline function print():Void
		this.flush();

	public inline function println():Void {
		lf();
		print();
	}

	inline function internal()
		return this;
}
