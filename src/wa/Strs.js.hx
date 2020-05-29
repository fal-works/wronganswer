package wa;

class Strs {
	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else js.Syntax.code("Number({0})", s); #end

	@:pure public static inline function toCharVec(s:String):haxe.ds.Vector<Char16> {
		final length = s.length;
		final vec = new haxe.ds.Vector<Char16>(length);
		for (i in 0...length)
			vec[i] = characterAt(s, i);
		return vec;
	}

	@:pure public static inline function compareString(a:String, b:String):Int
		return if (a < b) -1 else if (b < a) 1 else 0;

	@:pure public static inline function characterAt(s:String, index:Int):Char16
		return StringTools.fastCodeAt(s, index);
}
