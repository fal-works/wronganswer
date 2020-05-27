package wronganswer;

abstract CharIn(haxe.io.Input) {
	static var byteArray:#if macro Dynamic; #else java.NativeArray<java.types.Int8>; #end

	@:pure static inline function isNotWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				false;
			default:
				true;
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
			var byte = this.readByte();
			while (isNotWhiteSpace(byte)) {
				byteArray[index] = byte;
				++index;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		try {
			return #if macro ""; #else new String(byteArray, 0, index, "UTF-8"); #end
		} catch (e:Dynamic) {
			throw e;
		}
	}

	public inline function int():Int {
		var result = 0;
		var negative = false;
		try {
			var byte = this.readByte();
			if (byte == '-'.code) {
				negative = true;
				byte = this.readByte();
			}
			while (isNotWhiteSpace(byte)) {
				result = 10 * result + byte - "0".code;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return if (negative) -result else result;
	}

	public inline function float():Float
		return Ut.atof(token());

	public inline function tokenVec(length:Int):haxe.ds.Vector<String> {
		final vec = new haxe.ds.Vector<String>(length);
		for (i in 0...length)
			vec[i] = token();
		return vec;
	}

	public inline function intVec(length:Int):haxe.ds.Vector<Int> {
		final vec = new haxe.ds.Vector<Int>(length);
		for (i in 0...length)
			vec[i] = int();
		return vec;
	}

	public inline function floatVec(length:Int):haxe.ds.Vector<Float> {
		final vec = new haxe.ds.Vector<Float>(length);
		for (i in 0...length)
			vec[i] = float();
		return vec;
	}

	public inline function str(delimiter:Delimiter):String {
		final byteArray = CharIn.byteArray;
		var index = 0;

		try {
			var byte = this.readByte();
			while (byte != delimiter) {
				byteArray[index] = byte;
				++index;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		try {
			return #if macro ""; #else new String(byteArray, 0, index, "UTF-8"); #end
		} catch (e:Dynamic) {
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
			var byte = this.readByte();
			while (isNotWhiteSpace(byte)) {
				if (byte == characterCode)
					++foundCount;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return foundCount;
	}

	inline function uintWithRadix(radix:Int):Int {
		var result = 0;
		try {
			var byte = this.readByte();
			while (isNotWhiteSpace(byte)) {
				result = radix * result + byte - "0".code;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}
}

@:forward
abstract CharOut(StringBuffer) {
	public inline function new(capacity = 1024) {
		this = new StringBuffer(capacity);
	}

	public inline function print():Void
		java.lang.System.out.print(this.toString());

	public inline function println():Void
		java.lang.System.out.println(this.toString());
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
	public inline function new(capacity = 16) {
		this = #if macro null; #else new java.lang.StringBuilder(capacity); #end
	}

	public inline function str(s:String):StringBuffer
		return this.append(s);

	public inline function int(v:Int):StringBuffer
		return this.append(v);

	public inline function float(v:Float):StringBuffer
		return this.append(v);

	public inline function floatWithScale(v:Float, scale:Int):StringBuffer {
		if (v < 0) {
			this.appendCodePoint("-".code);
			v = -v;
		}
		v += Math.pow(10.0, -scale) / 2.0;

		this.append(cast(v, haxe.Int64));
		if (scale != 0) {
			this.appendCodePoint(".".code);
			v -= cast(cast(v, haxe.Int64), Float);

			for (i in 0...scale) {
				v *= 10.0;
				this.append(((cast v):Int));
				v -= Std.int(v);
			}
		}

		return this;
	}

	public inline function int64(v:haxe.Int64):StringBuffer
		return this.append(v);

	public inline function char(code:Int):StringBuffer
		return this.appendCodePoint(code);

	public inline function lf():StringBuffer
		return char("\n".code);

	public inline function space():StringBuffer
		return char(" ".code);
}

class Ut {
	@:pure public static inline function idiv(n:Int, divisor:Int):Int
		return untyped __java__("{0} / {1}", n, divisor);

	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else java.lang.Integer.parseInt(s, 10); #end

	@:pure public static inline function atof(s:String):Float
		return #if macro 0; #else java.lang.Double.DoubleClass.parseDouble(s); #end

	@:pure public static inline function ctoa(characterCode:Int):String
		return String.fromCharCode(characterCode);

	@:pure public static inline function ftoa(v:Float, scale:Int):String {
		final buffer = new StringBuffer(15 + scale);
		buffer.floatWithScale(v, scale);
		return buffer.toString();
	}
}
