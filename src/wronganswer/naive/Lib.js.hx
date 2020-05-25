package wronganswer.naive;

/**
	wronganswer / CC0
	https://github.com/fal-works/wronganswer
**/

abstract CharIn(#if macro Null<Dynamic> #else js.node.buffer.Buffer #end) {
	public extern inline function new()
		this = #if macro cast null; #else js.node.Buffer.alloc(1); #end

	public inline function byte() {
		#if !macro js.node.Fs.readSync(0, this, 0, 1, null); #end
		return this[0];
	}

	public inline function line() {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		while (true) {
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			final currentByte = this[0];
			if (currentByte == "\n".code)
				break;
			result += String.fromCharCode(currentByte);
		}
		#end
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
		return #if macro 0; #else js.Syntax.code("parseInt({0})", s); #end

	@:pure public static inline function atof(s:String):Float
		return Std.parseFloat(s);

	@:pure public static inline function itoa(i:Int):String
		return String.fromCharCode(i);
}
