package wa;

/**
	Character code.
**/
abstract Char(#if macro Int #else java.types.Int8 #end) from Int #if !macro to java.types.Int8 #end {
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
		Converts `this` to an decimal integer digit.
	**/
	public inline function toDigit():Int {
		return (cast this) - "0".code;
	}

	/**
		Converts `this` to `String`.
	**/
	public inline function toString():String
		return String.fromCharCode(cast this);

	/**
		Casts `this` to `Int`.
	**/
	@:to inline function int32():Int
		return #if macro this #else untyped __java__("(int) {0}", this); #end

	/**
		Casts `this` to 16bit char.
	**/
	inline function char16():#if macro Int #else java.types.Char16 #end
		return #if macro this #else untyped __java__("(char) {0}", this); #end
}
