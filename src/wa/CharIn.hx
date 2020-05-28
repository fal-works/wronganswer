package wa;

import wa.Char;

/**
	Character input.
**/
abstract CharIn(haxe.io.Input) {
	/**
		@param bufferCapacity Used on Java target.
	**/
	public extern inline function new(bufferCapacity:Int)
		this = Sys.stdin();

	/**
		Reads 1 byte.
	**/
	public inline function byte():Int
		return this.readByte();

	/**
		Reads 1 ASCII character.
	**/
	public inline function char():Char
		return byte();

	/**
		Reads a string separated by any whitespace character (SP, HL, CR or LF).
	**/
	public inline function str():String {
		var result = "";
		try {
			var character = char();
			while (character.isNotWhiteSpace()) {
				result += character.toString();
				character = char();
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}

	/**
		Reads an `Int` value separated by any whitespace character (SP, HL, CR or LF).
	**/
	public inline function int():Int {
		var result = 0;
		var negative = false;
		try {
			var character = char();
			if (character == "-".code) {
				negative = true;
				character = char();
			}
			while (character.isNotWhiteSpace()) {
				final digit = character.toDigit();
				#if debug
				if (digit < 0 || 10 <= digit)
					throw "Failed to parse.";
				#end
				result = 10 * result + digit;
				character = char();
			}
		} catch (e:haxe.io.Eof) {}

		return if (negative) -result else result;
	}

	/**
		Reads an `Int` value (assuming unsigned)
		separated by any whitespace character (SP, HL, CR or LF).
	**/
	public inline function uint():Int
		return uintWithRadix(10);

	/**
		Reads a binary integer separated by any whitespace character (SP, HL, CR or LF).
	**/
	public inline function binary():Int
		return uintWithRadix(2);

	/**
		Reads a sequence of `String` values separated by any whitespace characters (SP, HL, CR or LF).

		Note:
		- It first allocates an array with `length` and then assigns values.
		  On JS target there might be some tradeoffs here.
		- On Java target, `Vector` cannot be directly converted to `String`.
	**/
	public inline function strVec(length:Int):haxe.ds.Vector<String> {
		final vec = new haxe.ds.Vector<String>(length);
		for (i in 0...length)
			vec[i] = str();
		return vec;
	}

	/**
		Reads a sequence of `Int` values separated by any whitespace characters (SP, HL, CR or LF).
		@see `strVec()` for notes.
	**/
	public inline function intVec(length:Int):haxe.ds.Vector<Int> {
		final vec = new haxe.ds.Vector<Int>(length);
		for (i in 0...length)
			vec[i] = int();
		return vec;
	}

	/**
		Reads a sequence of `Int` values (assuming unsigned)
		separated by any whitespace characters (SP, HL, CR or LF).
		@see `strVec()` for notes.
	**/
	public inline function uintVec(length:Int):haxe.ds.Vector<Int> {
		final vec = new haxe.ds.Vector<Int>(length);
		for (i in 0...length)
			vec[i] = uint();
		return vec;
	}

	/**
		Reads an unsigned number and returns as `Int`.
		Alphabets must be in lower case.
	**/
	inline function uintWithRadix(radix:Int):Int {
		var result = 0;
		try {
			var character = char();
			while (character.isNotWhiteSpace()) {
				final digit = character.toDigit();
				#if debug
				if (digit < 0 || radix <= digit)
					throw "Failed to parse.";
				#end
				result = radix * result + digit;
				character = char();
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}
}
