package wronganswer;

abstract CharIn(haxe.io.Input) {
	@:pure static inline function isWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				true;
			default:
				false;
		}
	}

	public extern inline function new(bufferCapacity:Int)
		this = Sys.stdin();

	public inline function byte():Int
		return this.readByte();

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

	public inline function int():Int {
		final s = token();
		final value = Extensions.atoi(s);
		#if debug
		if (value == null)
			throw 'Failed to parse: $s';
		#end
		return value;
	}

	public inline function float():Float {
		final s = token();
		final value = Extensions.atof(s);
		#if debug
		if (!Math.isFinite(value))
			throw 'Failed to parse: $s';
		#end
		return value;
	}
}

@:forward
abstract CharOut(StringBuffer) from StringBuffer {
	public inline function new(capacity = 1024) {
		this = new StringBuffer(capacity);
	}

	public inline function flush():Void
		Sys.print(this.toString());

	public inline function flushln():Void
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

class Extensions {
	@:pure public static inline function atoi(s:String):Int
		return Std.parseInt(s);

	@:pure public static inline function atof(s:String):Float
		return Std.parseFloat(s);

	@:pure public static inline function itoa(i:Int):String
		return String.fromCharCode(i);
}
