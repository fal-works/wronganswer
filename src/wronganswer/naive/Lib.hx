package wronganswer.naive;

abstract CharIn(haxe.io.Input) {
	public extern inline function new()
		this = Sys.stdin();

	public inline function byte()
		return this.readByte();

	public inline function line()
		return this.readLine();

	public inline function lineSplit(delimiter:String = " ")
		return StringTools.trim(line()).split(delimiter);

	public inline function lineSplitInt(?delimiter:String)
		return lineSplit(delimiter).map(Extensions.atoi);
}

class Extensions {
	@:pure public static inline function atoi(s:String):Int
		return Std.parseInt(s);

	@:pure public static inline function atof(s:String):Float
		return Std.parseFloat(s);

	@:pure public static inline function itoa(i:Int):String
		return String.fromCharCode(i);
}
