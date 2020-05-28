package wa;

/**
	Character code.
**/
abstract Char(Int) from Int to Int {
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

	/**
		Converts `this` to `String`.
	**/
	public inline function toString():String
		return String.fromCharCode(this);
}
