package wa;

class Strs {
	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else java.lang.Integer.parseInt(s, 10); #end

	@:pure public static inline function ctoa(characterCode:Int):String
		return String.fromCharCode(characterCode);

	@:pure public static inline function compareString(a:String, b:String):Int
		return if (a < b) -1 else if (b < a) 1 else 0;
}