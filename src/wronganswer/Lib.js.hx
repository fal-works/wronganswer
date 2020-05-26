package wronganswer;

/**
	wronganswer / CC0
	https://github.com/fal-works/wronganswer
**/

abstract CharIn(#if macro Dynamic #else js.node.buffer.Buffer #end) {
	@:pure static inline function isNotWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				false;
			default:
				true;
		}
	}

	public extern inline function new(bufferCapacity:Int)
		this = #if macro null; #else js.node.Buffer.alloc(1); #end

	public inline function byte():Int {
		#if !macro
		js.node.Fs.readSync(0, this, 0, 1, null);
		#end
		return this[0];
	}

	public inline function digit():Int
		return byte() - "0".code;

	public inline function char():String
		return String.fromCharCode(byte());

	public inline function token():String {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		while (isNotWhiteSpace(byte)) {
			result += String.fromCharCode(byte);
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			byte = this[0];
		}
		#end

		return result;
	}

	public inline function int():Int {
		var result = 0;
		var negative = false;
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		if (byte == "-".code) {
			negative = true;
			readSync(0, this, 0, 1, null);
			byte = this[0];
		}
		while (isNotWhiteSpace(byte)) {
			result = 10 * result + byte - "0".code;
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			byte = this[0];
		}
		#end

		return if (negative) -result else result;
	}

	public inline function float():Float
		return Ut.atof(token());

	public inline function str(delimiter:Delimiter):String {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		while (byte != delimiter) {
			result += String.fromCharCode(byte);
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			byte = this[0];
		}
		#end

		return StringTools.rtrim(result);
	}

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

	public inline function uint():Int
		return uintWithRadix(10);

	public inline function binary():Int
		return uintWithRadix(2);

	public inline function count(characterCode:Int):Int {
		var foundCount = 0;
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		while (isNotWhiteSpace(byte)) {
			if (byte == characterCode)
				++foundCount;
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			final byte = this[0];
		}
		#end

		return foundCount;
	}

	inline function uintWithRadix(radix:Int):Int {
		var result = 0;
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		while (isNotWhiteSpace(byte)) {
			result = radix * result + byte - "0".code;
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			byte = this[0];
		}
		#end

		return result;
	}
}

@:forward
abstract CharOut(StringBuffer) from StringBuffer {
	public inline function new(capacity = 1024) {
		this = new StringBuffer(capacity);
	}

	public inline function print():Void {
		#if !macro
		js.Node.process.stdout.write(this.toString());
		#end
	}

	public inline function println():Void {
		#if !macro
		final write = js.Node.process.stdout.write;
		write(this.toString());
		write("\n");
		#end
	}
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
abstract StringBuffer(StringBuf) from StringBuf {
	public inline function new(?capacity) {
		this = new StringBuf();
	}

	public inline function str(s:String):StringBuffer
		return addDynamic(s);

	public inline function int(v:Int):StringBuffer
		return addDynamic(v);

	public inline function float(v:Float):StringBuffer
		return addDynamic(v);

	public inline function floatWithScale(v:Float, scale:Int):StringBuffer
		return addDynamic(Ut.ftoa(v, scale));

	public inline function int64(v:haxe.Int64):StringBuffer
		return addDynamic(Std.string(v));

	public inline function char(code:Int):StringBuffer {
		this.addChar(code);
		return this;
	}

	public inline function lf():StringBuffer
		return char("\n".code);

	public inline function space():StringBuffer
		return char(" ".code);

	inline function addDynamic(v:Dynamic):StringBuffer {
		this.add(v);
		return this;
	}
}

class Ut {
	public static macro function debug(message:haxe.macro.Expr):haxe.macro.Expr
		return macro null;

	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else js.Syntax.code("parseInt({0})", s); #end

	@:pure public static inline function atof(s:String):Float
		return Std.parseFloat(s);

	@:pure public static inline function itoa(i:Int):String
		return String.fromCharCode(i);

	@:pure public static inline function ftoa(v:Float, scale:Int):String {
		var result = if (v >= 0) "" else {
			v = -v;
			"-";
		};

		v += Math.pow(10.0, -scale) / 2.0;
		final integerPart = Std.int(v);

		if (scale != 0) {
			result += integerPart + ".";
			v -= integerPart;

			for (i in 0...scale){
					v *= 10.0;
					final integerPart = Std.int(v);
					result += integerPart;
					v -= integerPart;
			}
		}

		return result;
	}

	@:generic @:noUsing
	public static inline function vec<T>(length:Int, factory:(index:Int) -> T):haxe.ds.Vector<T> {
		final vec = new haxe.ds.Vector<T>(length);
		for (i in 0...length)
			vec[i] = factory(i);
		return vec;
	}
}
