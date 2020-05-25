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
	public static macro function debug(message:haxe.macro.Expr):haxe.macro.Expr
		return macro null;

	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else java.lang.Integer.parseInt(s, 10); #end

	@:pure public static inline function atof(s:String):Float
		return #if macro 0; #else java.lang.Double.DoubleClass.parseDouble(s); #end

	@:pure public static inline function itoa(i:Int):String
		return String.fromCharCode(i);
}
