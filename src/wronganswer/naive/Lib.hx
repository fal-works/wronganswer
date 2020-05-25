package wronganswer.naive;

private typedef CharInData = #if js js.node.buffer.Buffer #else haxe.io.Input #end;

abstract CharIn(CharInData) {
	public extern inline function new() {
		#if java
		this = Sys.stdin();
		#elseif js
		this = js.node.Buffer.alloc(1);
		#else
		this = Sys.stdin();
		#end
	}

	public inline function byte() {
		#if js
		js.node.Fs.readSync(0, this, 0, 1, null);
		return this[0];
		#else
		return this.readByte();
		#end
	}

	public inline function line() {
		#if js
		final readSync = js.node.Fs.readSync;
		var result = "";
		while (true) {
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			final currentByte = this[0];
			if (currentByte == "\n".code)
				break;
			result += String.fromCharCode(currentByte);
		}
		return result;
		#else
		return this.readLine();
		#end
	}

	public inline function lineSplit(delimiter:String = " ")
		return StringTools.trim(line()).split(delimiter);

	public inline function lineSplitInt(?delimiter:String)
		return lineSplit(delimiter).map(Extensions.atoi);
}

class Extensions {
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
		return #if java java.lang.Double.DoubleClass.parseDouble(s); #else Std.parseFloat(s); #end
	}

	@:pure
	public static inline function itoa(i:Int):String
		return String.fromCharCode(i);
}
