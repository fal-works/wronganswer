package wronganswer;

abstract CharIn(#if macro Dynamic #else js.node.buffer.Buffer #end) {
	@:pure static inline function isWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				true;
			default:
				false;
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

	public inline function char():String
		return String.fromCharCode(byte());

	public inline function digit():Int {
		final charCode = byte();
		#if debug
		if (charCode < "0".code || charCode > "9".code)
			throw 'Failed to get digit. Character code: $charCode';
		#end
		return charCode - "0".code;
	}

	public inline function token():String {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		while (true) {
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			final currentByte = this[0];
			if (isWhiteSpace(currentByte))
				break;
			result += String.fromCharCode(currentByte);
		}
		#end

		return result;
	}

	public inline function str(delimiter:Delimiter):String {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		while (true) {
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			final currentByte = this[0];
			if (currentByte == delimiter)
				break;
			result += String.fromCharCode(currentByte);
		}
		#end

		return StringTools.rtrim(result);
	}

	public inline function int():Int
		return Ut.atoi(token());

	public inline function float():Float
		return Ut.atof(token());
}

@:forward
abstract CharOut(StringBuffer) from StringBuffer {
	public inline function new(capacity = 1024) {
		this = new StringBuffer(capacity);
	}

	public inline function print():Void
		#if macro return; #else js.Node.process.stdout.write(this.toString()); #end

	public inline function println():Void
		#if macro return; #else js.Node.process.stdout.write(this.toString() + "\n"); #end
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

	public inline function str(s:String):CharOut
		return addDynamic(s);

	public inline function int(v:Int):CharOut
		return addDynamic(v);

	public inline function float(v:Float):CharOut
		return addDynamic(v);

	public inline function int64(v:haxe.Int64):CharOut
		return addDynamic(Std.string(v));

	public inline function char(code:Int):CharOut {
		this.addChar(code);
		return this;
	}

	public inline function lf():CharOut
		return char("\n".code);

	public inline function space():CharOut
		return char(" ".code);

	inline function addDynamic(v:Dynamic):CharOut {
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
}
