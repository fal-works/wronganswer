package wa;

abstract Char32(Int) from Int to Int {
	public inline function isNotWhiteSpace():Bool {
		return switch this {
			case " ".code | "\t".code | "\n".code | "\r".code:
				false;
			default:
				true;
		}
	}

	public inline function toDigit():Int
		return this - "0".code;

	public inline function toString():String
		return String.fromCharCode(this);

	inline function char16():#if macro Int #else java.types.Char16 #end
		return #if macro this; #else untyped __java__("(char) {0}", this); #end
}
