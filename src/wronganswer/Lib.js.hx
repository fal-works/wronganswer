package wronganswer;

abstract CharIn(js.node.buffer.Buffer) {
	@:pure static inline function isWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				true;
			default:
				false;
		}
	}

	public extern inline function new(bufferCapacity:Int)
		this = js.node.Buffer.alloc(1);

	public inline function byte():Int {
		js.node.Fs.readSync(0, this, 0, 1, null);
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
		final readSync = js.node.Fs.readSync;
		var result = "";
		while (true) {
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			final currentByte = this[0];
			if (isWhiteSpace(currentByte))
				break;
			result += String.fromCharCode(currentByte);
		}

		return result;
	}

	public inline function str(delimiter:Delimiter):String {
		final readSync = js.node.Fs.readSync;
		var result = "";
		while (true) {
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			final currentByte = this[0];
			if (currentByte == delimiter)
				break;
			result += String.fromCharCode(currentByte);
		}

		return StringTools.rtrim(result);
	}

	public inline function int():Int
		return Statics.atoi(token());

	public inline function float():Float
		return Statics.atof(token());
}

@:forward
abstract CharOut(StringBuffer) from StringBuffer {
	public inline function new(capacity = 1024) {
		this = new StringBuffer(capacity);
	}

	public inline function flush():Void
		js.Node.process.stdout.write(this.toString());

	public inline function flushln():Void
		js.Node.process.stdout.write(this.toString() + "\n");
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

class Statics {
	public static inline function debug(message:String):Void {}

	@:pure public static inline function atoi(s:String):Int
		return cast js.Lib.parseInt(s, 10);

	@:pure public static inline function atof(s:String):Float
		return Std.parseFloat(s);

	@:pure public static inline function itoa(i:Int):String
		return String.fromCharCode(i);
}