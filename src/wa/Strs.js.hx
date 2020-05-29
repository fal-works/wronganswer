package wa;

class Strs {
	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else js.Syntax.code("parseInt({0})", s); #end

	@:pure public static inline function compareString(a:String, b:String):Int
		return if (a < b) -1 else if (b < a) 1 else 0;

	@:pure public static inline function characterAt(s:String, index:Int):Char16
		return StringTools.fastCodeAt(s, index);
}
