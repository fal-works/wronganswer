package wronganswer;

/**
	wronganswer / CC0
	https://github.com/fal-works/wronganswer
**/

abstract CharIn(haxe.io.Input) {
	static var byteArray:#if macro Dynamic; #else java.NativeArray<java.types.Int8>; #end

	@:pure static inline function isWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				true;
			default:
				false;
		}
	}

	public extern inline function new(bufferCapacity:Int) {
		this = Sys.stdin();
		#if !macro
		byteArray = new java.NativeArray(bufferCapacity);
		#end
	}

	public inline function byte():Int
		return this.readByte();

	public inline function digit():Int
		return byte() - "0".code;

	public inline function char():String
		return String.fromCharCode(byte());

	public inline function token():String {
		final byteArray = CharIn.byteArray;
		var index = 0;

		try {
			while (true) {
				final currentByte = this.readByte();
				if (isWhiteSpace(currentByte))
					break;
				byteArray[index] = currentByte;
				++index;
			}
		} catch (e:haxe.io.Eof) {}

		try {
			return #if macro ""; #else new String(byteArray, 0, index, "UTF-8"); #end
		} catch (e) {
			throw e;
		}
	}

	public inline function int():Int
		return Ut.atoi(token());

	public inline function float():Float
		return Ut.atof(token());

	public inline function str(delimiter:Delimiter):String {
		final byteArray = CharIn.byteArray;
		var index = 0;

		try {
			while (true) {
				final currentByte = this.readByte();
				if (currentByte == delimiter)
					break;
				byteArray[index] = currentByte;
				++index;
			}
		} catch (e:haxe.io.Eof) {}

		try {
			return #if macro ""; #else new String(byteArray, 0, index, "UTF-8"); #end
		} catch (e) {
			throw e;
		}
	}

	public inline function uint():Int
		return uintWithRadix(10);

	public inline function binary():Int
		return uintWithRadix(2);

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

	inline function uintWithRadix(radix:Int):Int {
		var result = 0;
		try {
			while (true) {
				final currentByte = this.readByte();
				if (isWhiteSpace(currentByte))
					break;

				result = radix * result + currentByte - "0".code;
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}
}

@:forward
abstract CharOut(StringBuffer) from StringBuffer {
	public inline function new(capacity = 1024) {
		this = new StringBuffer(capacity);
	}

	public inline function print():Void
		Sys.print(this.toString());

	public inline function println():Void
		Sys.println(this.toString());
}

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

@:forward(length, toString)
abstract StringBuffer(#if macro Dynamic #else java.lang.StringBuilder #end)
#if !macro from java.lang.StringBuilder
#end
{
	public inline function new(capacity = 1024) {
		this = #if macro null; #else new java.lang.StringBuilder(capacity); #end
	}

	public inline function str(s:String):CharOut
		return this.append(s);

	public inline function int(v:Int):CharOut
		return this.append(v);

	public inline function float(v:Float):CharOut
		return this.append(v);

	public inline function int64(v:haxe.Int64):CharOut
		return this.append(v);

	public inline function char(code:Int):CharOut
		return this.appendCodePoint(code);

	public inline function lf():CharOut
		return char("\n".code);

	public inline function space():CharOut
		return char(" ".code);
}

class Ut {
	public static macro function debug(message:haxe.macro.Expr):haxe.macro.Expr
		return macro null;

	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else java.lang.Integer.parseInt(s, 10); #end

	@:pure public static inline function atof(s:String):Float
		return #if macro 0; #else java.lang.Double.DoubleClass.parseDouble(s); #end

	@:pure public static inline function itoa(i:Int):String
		return String.fromCharCode(i);
}
