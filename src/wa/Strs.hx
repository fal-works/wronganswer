package wa;

import wa.Char16;
import wa.Vec;

/**
	Utility static function for `String` type.
**/
class Strs {
	/**
		Converts `s` to `Int`.
	**/
	@:pure public static inline function atoi(s:String):Int {
		final i = Std.parseInt(s);
		#if debug
		if (i == null)
			throw 'Failed to parse: $s';
		#end
		return i;
	}

	/**
		Converts `s` to a vector of `Char16`.
	**/
	@:pure public static inline function toCharVec(s:String):Vec<Char16> {
		final length = s.length;
		final vec = new Vec<Char16>(length);
		for (i in 0...length)
			vec[i] = characterAt(s, i);
		return vec;
	}

	/**
		Compares two strings in dictionary order.
		@return Negative if `a` comes before `b`. `0` if equal.
	**/
	@:pure public static inline function compareString(a:String, b:String):Int
		return if (a < b) -1 else if (b < a) 1 else 0;

	/**
		@return The character code at `index`.
	**/
	@:pure public static inline function characterAt(s:String, index:Int):Char16
		return StringTools.fastCodeAt(s, index);
}
