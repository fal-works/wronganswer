package wronganswer.naive;

abstract CharIn(js.node.buffer.Buffer) {
	public extern inline function new()
		this = js.node.Buffer.alloc(1);

	public inline function byte() {
		js.node.Fs.readSync(0, this, 0, 1, null);
		return this[0];
	}

	public inline function line() {
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
	}

	public inline function lineSplit(delimiter:String = " ")
		return StringTools.trim(line()).split(delimiter);

	public inline function lineSplitInt(?delimiter:String)
		return lineSplit(delimiter).map(Ut.atoi);
}

class Ut {
	public static macro function debug(message:haxe.macro.Expr):haxe.macro.Expr
		return macro null;

	@:pure public static inline function atoi(s:String):Int
		return cast js.Lib.parseInt(s, 10);

	@:pure public static inline function atof(s:String):Float
		return Std.parseFloat(s);

	@:pure public static inline function itoa(i:Int):String
		return String.fromCharCode(i);
}
