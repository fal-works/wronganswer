package wronganswer;

typedef CharInData = #if js js.node.buffer.Buffer #else haxe.io.Input #end;

abstract CharIn(CharInData) {
	#if java
	static var byteArray:java.NativeArray<java.types.Int8>;
	#end

	public extern inline function new(bufferCapacity:Int) {
		#if java
		this = Sys.stdin();
		byteArray = new java.NativeArray(bufferCapacity);
		#elseif js
		this = js.node.Buffer.alloc(1);
		#else
		this = Sys.stdin();
		#end
	}

	public inline function byte():Int {
		#if js
		js.node.Fs.readSync(0, this, 0, 1, null);
		return this[0];
		#else
		return this.readByte();
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

	#if java
	public inline function str(delimiter:Delimiter):String {
		final byteArray = CharIn.byteArray;
		var index = 0;
		var leftTrim = true;

		try {
			while (true) {
				final currentByte = this.readByte();
				if (leftTrim) {
					switch currentByte {
						case " ".code:
							continue;
						case "\t".code:
							continue;
						case "\n".code:
							continue;
						case "\r".code:
							continue;
						default:
							leftTrim = false;
					}
				}

				if (currentByte == delimiter)
					break;
				byteArray[index] = currentByte;
				++index;
			}
		} catch (e:haxe.io.Eof) {}

		// right trim
		while (index != 0) {
			switch (byteArray[--index]) {
				case " ".code:
					continue;
				case "\t".code:
					continue;
				case "\n".code:
					continue;
				case "\r".code:
					continue;
				default:
			}
			break;
		}

		try {
			return new String(byteArray, 0, index + 1, "UTF-8");
		} catch (e) {
			throw e;
		}
	}
	#elseif js
	public inline function str(delimiter:Delimiter):String {
		var leftTrim = true;
		var result = "";
		while (true) {
			if (js.node.Fs.readSync(0, this, 0, 1, null) == 0)
				break;
			final currentByte = this[0];

			if (leftTrim) {
				switch currentByte {
					case " ".code:
						continue;
					case "\t".code:
						continue;
					case "\n".code:
						continue;
					case "\r".code:
						continue;
					default:
						leftTrim = false;
				}
			}
			if (currentByte == delimiter)
				break;
			result += String.fromCharCode(currentByte);
		}

		return StringTools.rtrim(result);
	}
	#else
	public inline function str(delimiter:Delimiter):String {
		var result = "";
		try {
			var leftTrim = true;
			while (true) {
				final currentByte = this.readByte();
				if (leftTrim) {
					switch currentByte {
						case " ".code:
							continue;
						case "\t".code:
							continue;
						case "\r".code:
							continue;
						case "\n".code:
							continue;
						default:
							leftTrim = false;
					}
				}
				if (currentByte == delimiter)
					break;
				result += String.fromCharCode(currentByte);
			}
		} catch (e:haxe.io.Eof) {}

		return StringTools.rtrim(result);
	}
	#end

	public inline function int(delimiter:Delimiter):Int {
		final s = str(delimiter);
		final value = Parser.atoi(s);
		#if debug
		if (value == null)
			throw 'Failed to parse: $s';
		#end
		return value;
	}

	public inline function float(delimiter:Delimiter):Float {
		final s = str(delimiter);
		final value = Parser.atof(s);
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

	public inline function flush():Void {
		#if js
		js.Node.process.stdout.write(this.toString());
		#else
		Sys.print(this.toString());
		#end
	}

	public inline function flushln():Void {
		#if js
		js.Node.process.stdout.write(this.toString() + "\n");
		#else
		Sys.println(this.toString());
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

	public inline function int64(v:haxe.Int64):CharOut
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

class Parser {
	@:pure
	public static inline function atoi(s:String):Int {
		return #if java
			java.lang.Integer.parseInt(s, 10);
		#elseif js
			cast js.Lib.parseInt(s, 10);
		#else
			Std.parseInt(s);
		#end
	}

	@:pure
	public static inline function atof(s:String):Float {
		return #if java
			java.lang.Double.DoubleClass.parseDouble(s);
		#else
			Std.parseFloat(s);
		#end
	}
}
