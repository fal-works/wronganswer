package wronganswer;

/**
	wronganswer / CC0
	https://github.com/fal-works/wronganswer
**/

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
		return Ut.atof(token());

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
		Appends a `Float` value.
	**/
	public inline function float(v:Float):CharOut
		return addDynamic(v);

	/**
		Appends a `Float` value with `scale`.
		@param scale The number of fractional digits.
	**/
	public inline function floatWithScale(v:Float, scale:Int):CharOut
		return addDynamic(Ut.ftoa(v, scale));

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

	/**
		Converts `v` to `String`.
		@param scale The number of fractional digits.
	**/
	@:pure public static inline function ftoa(v:Float, scale:Int):String {
		var result = if (v >= 0) "" else {
			v = -v;
			"-";
		};

		v += Math.pow(10.0, -scale) / 2.0;
		final integerPart = Math.ffloor(v);

		if (scale != 0) {
			result += integerPart + ".";
			v -= integerPart;

			for (i in 0...scale){
					v *= 10.0;
					result += Std.int(v);
					v -= Std.int(v);
			}
		}

		return result;
	}

	/**
		Creates a vector of elements returned from `factory()` callback.

		Note:
		- It first allocates an array with `length` and then assigns values.
		  On JS target there might be some tradeoffs here.
		- On Java target, `Vector` cannot be directly converted to `String`.
	**/
	@:generic
	public static inline function vec<T>(length:Int, factory:(index:Int) -> T):haxe.ds.Vector<T> {
		final vec = new haxe.ds.Vector<T>(length);
		for (i in 0...length)
			vec[i] = factory(i);
		return vec;
	}
}
