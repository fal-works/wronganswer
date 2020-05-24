package wronganswer;

import haxe.Int64;

typedef StringBufferData = #if java java.lang.StringBuilder #else StringBuf #end;

@:forward(length, toString)
abstract StringBuffer(StringBufferData) from StringBufferData {
	public inline function new(capacity = 1024) {
		this = new StringBufferData(#if java capacity #end);
	}

	public inline function str(s:String):CharOut
		return #if java this.append(s); #else addDynamic(s); #end

	public inline function int(v:Int):CharOut
		return #if java this.append(v); #else addDynamic(v); #end

	public inline function float(v:Float):CharOut
		return #if java this.append(v); #else addDynamic(v); #end

	public inline function int64(v:Int64):CharOut
		return #if java this.append(v); #else addDynamic(Std.string(v)); #end

	public inline function char(code:Int):CharOut {
		#if java
		return this.appendCodePoint(code);
		#else
		this.addChar(code);
		return this;
		#end
	}

	public inline function lf():CharOut
		return char("\n".code);

	public inline function space():CharOut
		return char(" ".code);

	#if !java
	inline function addDynamic(v:Dynamic):CharOut {
		this.add(v);
		return this;
	}
	#end
}

@:forward
abstract CharOut(StringBuffer) from StringBuffer {
	public inline function new(capacity = 1024) {
		this = new StringBuffer(capacity);
	}

	public inline function flush():Void {
		#if js
		(untyped process).stdout.write(this.toString());
		#elseif sys
		Sys.print(this.toString());
		#else
		throw "Unsupported operation.";
		#end
	}

	public inline function flushln():Void {
		#if js
		(untyped process).stdout.write(this.toString() + "\n");
		#elseif sys
		Sys.println(this.toString());
		#else
		throw "Unsupported operation.";
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

class CharIn {
	#if js
	final byteBox = js.node.Buffer.alloc(1);
	#elseif java
	final stdin = Sys.stdin();
	final byteArray:java.NativeArray<java.types.Int8>;
	#else
	final stdin = Sys.stdin();
	#end

	public extern inline function new(bufferCapacity:Int) {
		#if java
		this.byteArray = new java.NativeArray(bufferCapacity);
		#end
	}

	public inline function byte():Int {
		#if js
		final byteBox = this.byteBox;
		js.node.Fs.readSync(0, byteBox, 0, 1, null);
		return byteBox[0];
		#else
		return this.stdin.readByte();
		#end
	}

	public inline function char():String
		return String.fromCharCode(byte());

	public inline function digit():Int {
		final charCode = byte();
		#if debug
		if (charCode < "0".code || charCode > "9".code)
			throw 'Failed get digit. Character code: $charCode';
		#end
		return charCode - "0".code;
	}

	#if js
	public inline function str(delimiter:Delimiter):String {
		final byteBox = this.byteBox;
		inline function readByte()
			return if (js.node.Fs.readSync(0, byteBox, 0, 1, null) != 0) byteBox[0] else 0;

		var currentByte = readByte();
		var result = "";
		while (currentByte != delimiter && currentByte != 0) {
			result += String.fromCharCode(currentByte);
			currentByte = readByte();
		}

		return result;
	}
	#elseif java
	public inline function str(delimiter:Delimiter):String {
		final stdin = this.stdin;
		final byteArray = this.byteArray;
		var index = 0;
		var currentByte:Int;

		try {
			while ((currentByte = stdin.readByte()) != delimiter)
				byteArray[index++] = currentByte;
		} catch (e) {}

		try {
			return new String(byteArray, 0, index, "UTF-8");
		} catch (e) {
			throw e;
		}
	}
	#else
	public inline function str(delimiter:Delimiter):String
		return this.stdin.readUntil(delimiter);
	#end

	public inline function int(delimiter:Delimiter):Int {
		final s = this.str(delimiter);
		final value = Std.parseInt(s);
		#if debug
		if (value == null)
			throw 'Failed to parse: $s';
		#end
		return value;
	}

	public inline function float(delimiter:Delimiter):Float {
		final s = this.str(delimiter);
		final value = Std.parseFloat(s);
		#if debug
		if (!Math.isFinite(value))
			throw 'Failed to parse: $s';
		#end
		return value;
	}

	public inline function close():Void {
		#if !js
		this.stdin.close();
		#end
	}
}
