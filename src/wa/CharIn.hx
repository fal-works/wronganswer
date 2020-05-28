package wa;

import wa.Util;
import wa.Delimiter;

/**
	Character input.
**/
abstract CharIn(haxe.io.Input) {
	@:pure static inline function isNotWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				false;
			default:
				true;
		}
	}

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
		Reads 1 decimal digit.
	**/
	public inline function digit():Int {
		final charCode = byte();
		#if debug
		if (charCode < "0".code || charCode > "9".code)
			throw 'Failed to parse: $charCode';
		#end
		return charCode - "0".code;
	}

	/**
		Reads 1 ASCII character.
	**/
	public inline function char():String
		return String.fromCharCode(byte());

	/**
		Reads a string separated by any whitespace character (SP, HL, CR or LF).
	**/
	public inline function token():String {
		var result = "";
		try {
			var byte = this.readByte();
			while (isNotWhiteSpace(byte)) {
				result += String.fromCharCode(byte);
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}

	/**
		Reads an `Int` value.
	**/
	public inline function int():Int {
		var result = 0;
		var negative = false;
		try {
			var byte = this.readByte();
			if (byte == "-".code) {
				negative = true;
				byte = this.readByte();
			}
			while (isNotWhiteSpace(byte)) {
				final digit = byte - "0".code;
				#if debug
				if (digit < 0 || 10 <= digit)
					throw "Failed to parse.";
				#end
				result = 10 * result + digit;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return if (negative) -result else result;
	}

	/**
		Reads a `Float` value.
	**/
	public inline function float():Float
		return Util.atof(token());

	/**
		Reads a sequence of `String` values separated by any whitespace characters (SP, HL, CR or LF).

		Note:
		- It first allocates an array with `length` and then assigns values.
		  On JS target there might be some tradeoffs here.
		- On Java target, `Vector` cannot be directly converted to `String`.
	**/
	public inline function tokenVec(length:Int):haxe.ds.Vector<String> {
		final vec = new haxe.ds.Vector<String>(length);
		for (i in 0...length)
			vec[i] = token();
		return vec;
	}

	/**
		Reads a sequence of `Int` values separated by any whitespace characters (SP, HL, CR or LF).

		Note:
		- It first allocates an array with `length` and then assigns values.
		  On JS target there might be some tradeoffs here.
		- On Java target, `Vector` cannot be directly converted to `String`.
	**/
	public inline function intVec(length:Int):haxe.ds.Vector<Int> {
		final vec = new haxe.ds.Vector<Int>(length);
		for (i in 0...length)
			vec[i] = int();
		return vec;
	}

	/**
		Reads a sequence of `Float` values separated by any whitespace characters (SP, HL, CR or LF).

		Note:
		- It first allocates an array with `length` and then assigns values.
		  On JS target there might be some tradeoffs here.
		- On Java target, `Vector` cannot be directly converted to `String`.
	**/
	public inline function floatVec(length:Int):haxe.ds.Vector<Float> {
		final vec = new haxe.ds.Vector<Float>(length);
		for (i in 0...length)
			vec[i] = float();
		return vec;
	}

	/**
		Reads until `delimiter`.
	**/
	public inline function str(delimiter:Delimiter):String {
		var result = "";
		try {
			var byte = this.readByte();
			while (byte != delimiter) {
				result += String.fromCharCode(byte);
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return StringTools.rtrim(result);
	}

	/**
		Reads an `Int` value assuming unsigned.
	**/
	public inline function uint():Int
		return uintWithRadix(10);

	/**
		Reads a binary integer.
	**/
	public inline function binary():Int
		return uintWithRadix(2);

	/**
		Reads a string separated by any whitespace character (SP, HL, CR or LF)
		and counts the number of `characterCode`.
	**/
	public inline function count(characterCode:Int):Int {
		var foundCount = 0;
		try {
			var byte = this.readByte();
			while (isNotWhiteSpace(byte)) {
				if (byte == characterCode)
					++foundCount;

				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return foundCount;
	}

	/**
		Reads an unsigned number and returns as `Int`.
		Alphabets must be in lower case.
	**/
	inline function uintWithRadix(radix:Int):Int {
		var result = 0;
		try {
			var byte = this.readByte();
			while (isNotWhiteSpace(byte)) {
				final digit = byte - "0".code;
				#if debug
				if (digit < 0 || radix <= digit)
					throw "Failed to parse.";
				#end
				result = radix * result + digit;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}
}
