package wa;

import wa.Char32;
import wa.Vec;

/**
	Character input.
**/
abstract CharIn(haxe.io.Input) {
	/**
		@param bufferCapacity Used on java/js targets.
	**/
	public extern inline function new(bufferCapacity:Int)
		this = Sys.stdin();

	/**
		Reads 1 byte ASCII character.
	**/
	public inline function char():Char32
		return this.readByte();

	/**
		Reads a string separated by any whitespace character (SP, HL, CR or LF).
	**/
	public inline function str():String {
		var result = "";
		try {
			var character:Char32;
			while ((character = char()).isNotWhiteSpace())
				result += character.toString();
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
		Reads a sequence of `String` values separated by any whitespace characters (SP, HL, CR or LF).

		Note:
		- It first allocates an array with `length` and then assigns values.
		  On JS target there might be some tradeoffs here.
		- On Java target, `Vector` cannot be directly converted to `String`.
	**/
	public inline function strVec(length:Int):Vec<String> {
		final vec = new Vec<String>(length);
		for (i in 0...length)
			vec[i] = str();
		return vec;
	}

	/**
		Reads a sequence of `Int` values separated by any whitespace characters (SP, HL, CR or LF).
		@see `strVec()` for notes.
	**/
	public inline function intVec(length:Int):Vec<Int> {
		final vec = new Vec<Int>(length);
		for (i in 0...length)
			vec[i] = int();
		return vec;
	}

	/**
		Reads a sequence of `Int` values (assuming unsigned)
		separated by any whitespace characters (SP, HL, CR or LF).
		@see `strVec()` for notes.
	**/
	public inline function uintVec(length:Int):Vec<Int> {
		final vec = new Vec<Int>(length);
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
			var character:Char32;
			while ((character = char()).isNotWhiteSpace()) {
				final digit = character.toDigit();
				#if debug
				if (digit < 0 || radix <= digit)
					throw "Failed to parse.";
				#end
				result = radix * result + digit;
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}

	inline function internal()
		return this;
}
