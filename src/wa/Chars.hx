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

	/**
		@return `true` if `characterCode` is not a whitespace (SP, HT, LF or CR).
	**/
	@:pure public static inline function isNotWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				false;
			default:
				true;
		}
	}
}
