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
		return lineSplit(delimiter).map(Ut.atoi);
}

class Ut {
	public static inline function debug(message:String):Void {}

	@:pure public static inline function atoi(s:String):Int
		return java.lang.Integer.parseInt(s, 10);

	@:pure public static inline function atof(s:String):Float
		return java.lang.Double.DoubleClass.parseDouble(s);

	@:pure public static inline function itoa(i:Int):String
		return String.fromCharCode(i);
}
