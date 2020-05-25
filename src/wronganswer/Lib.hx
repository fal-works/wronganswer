package wronganswer;

/**
	wronganswer / CC0
	https://github.com/fal-works/wronganswer
**/

/**
	Character input.
**/
abstract CharIn(haxe.io.Input) {
	@:pure static inline function isWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				true;
			default:
				false;
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
			while (true) {
				final currentByte = this.readByte();
				if (isWhiteSpace(currentByte))
					break;
				result += String.fromCharCode(currentByte);
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}

	/**
		Reads an `Int` value.
	**/
	public inline function int():Int
		return Ut.atoi(token());

	/**
		Reads a `Float` value.
	**/
	public inline function float():Float
		return Ut.atof(token());

	/**
		Reads until `delimiter`.
	**/
	public inline function str(delimiter:Delimiter):String {
		var result = "";
		try {
			while (true) {
				final currentByte = this.readByte();
				if (currentByte == delimiter)
					break;
				result += String.fromCharCode(currentByte);
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
			while (true) {
				final currentByte = this.readByte();
				if (isWhiteSpace(currentByte))
					break;

				if (currentByte == characterCode)
					++foundCount;
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
			while (true) {
				final currentByte = this.readByte();
				if (isWhiteSpace(currentByte))
					break;

				final digit = currentByte - "0".code;
				#if debug
				if (digit < 0 || radix <= digit)
					throw "Failed to parse.";
				#end
				result = radix * result + digit;
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}
}

/**
	Character output.
**/
@:forward
abstract CharOut(StringBuffer) from StringBuffer {
	/**
		@param capacity Used on Java target.
	**/
	public inline function new(capacity = 1024) {
		this = new StringBuffer(capacity);
	}

	/**
		Prints the buffered string.
	**/
	public inline function print():Void
		Sys.print(this.toString());

	/**
		Prints the buffered string with CR and/or LF.
	**/
	public inline function println():Void
		Sys.println(this.toString());
}

/**
	Character codes used as string delimiters.
**/
enum abstract Delimiter(Int) to Int {
	final LF = "\n".code;
	final SP = " ".code;
	final HT = "\t".code;
	final Slash = "/".code;
	final BackSlash = "\\".code;
	final Pipe = "|".code;
	final Comma = ",".code;
	final Dot = ".".code;
}

/**
	Buffer object for building `String` by appending small elements.
**/
@:forward(length, toString)
abstract StringBuffer(StringBuf) from StringBuf {
	public inline function new(?capacity) {
		this = new StringBuf();
	}

	/**
		Appends a `String` value.
	**/
	public inline function str(s:String):CharOut
		return addDynamic(s);

	/**
		Appends an `Int` value.
	**/
	public inline function int(v:Int):CharOut
		return addDynamic(v);

	/**
		Appens a `Float` value.
	**/
	public inline function float(v:Float):CharOut
		return addDynamic(v);

	/**
		Appends an `Int64` value.
	**/
	public inline function int64(v:haxe.Int64):CharOut
		return addDynamic(Std.string(v));

	/**
		Appends an ASCII character.
	**/
	public inline function char(characterCode:Int):CharOut {
		this.addChar(characterCode);
		return this;
	}

	/**
		Appends an LF.
	**/
	public inline function lf():CharOut
		return char("\n".code);

	/**
		Appends a space.
	**/
	public inline function space():CharOut
		return char(" ".code);

	inline function addDynamic(v:Dynamic):CharOut {
		this.add(v);
		return this;
	}
}

/**
	Utility static functions.
**/
class Ut {
	/**
		Prints a debug log `#if debug`.
		Has no effect on Java/JS targets.
	**/
	public static macro function debug(message:haxe.macro.Expr):haxe.macro.Expr {
		#if debug
		return macro Sys.println('[DEBUG] ' + Std.string($message));
		#else
		return macro null;
		#end
	}

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
		Converts `s` to `Float`.
	**/
	@:pure public static inline function atof(s:String):Float {
		final f = Std.parseFloat(s);
		#if debug
		if (!Math.isFinite(f))
			throw 'Failed to parse: $s';
		#end
		return f;
	}

	/**
		Converts `characterCode` to `String`.
	**/
	@:pure public static inline function itoa(characterCode:Int):String
		return String.fromCharCode(characterCode);
}
