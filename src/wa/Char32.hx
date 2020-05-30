package wa;

import wa.Char16;

/**
	Character code based on `Int`.
	Mainly used as input character.
**/
abstract Char32(Int) from Int to Int to Char16 {
	/**
		@return `true` if `characterCode` is not a whitespace (SP, HT, LF or CR).
	**/
	public inline function isNotWhiteSpace():Bool {
		return switch this {
			case " ".code | "\t".code | "\n".code | "\r".code:
				false;
			default:
				true;
		}
	}

	/**
		Converts `this` to an integer digit.
	**/
	public inline function toDigit():Int
		return this - "0".code;

	/**
		Converts `this` to `String`.
	**/
	public inline function toString():String
		return String.fromCharCode(this);
}
