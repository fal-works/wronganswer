package wa;

/**
	Utility static functions for character codes.
**/
class Chars {
	/**
		Converts `characterCode` to `String`.
	**/
	@:pure public static inline function ctoa(characterCode:Int):String
		return String.fromCharCode(characterCode);
}
