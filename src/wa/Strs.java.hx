package wa;

class Strs {
	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else java.lang.Integer.parseInt(s, 10); #end

	@:pure public static inline function toCharVec(s:String):haxe.ds.Vector<Char16>
		return #if macro null; #else untyped __java__("{0}.toCharArray()", s); #end

	@:pure public static inline function compareString(a:String, b:String):Int
		return if (a < b) -1 else if (b < a) 1 else 0;

	@:pure public static inline function characterAt(s:String, index:Int):Char16
		return #if macro ""; #else untyped __java__("{0}.charAt({1})", s, index); #end
}
