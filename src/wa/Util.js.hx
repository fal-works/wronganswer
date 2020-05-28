package wa;

class Util {
	@:generic public static inline function print<T>(x:T):Void {
		#if !macro
		js.Node.process.stdout.write("" + x);
		#end
	}

	@:generic public static inline function println<T>(x:T):Void {
		#if !macro
		js.Node.process.stdout.write("" + x);
		js.Node.process.stdout.write("\n");
		#end
	}

	@:pure @:noUsing public static inline function imin(a:Int, b:Int):Int
		return if (a < b) a else b;

	@:pure @:noUsing public static inline function imax(a:Int, b:Int):Int
		return if (a < b) b else a;

	@:pure public static inline function idiv(n:Int, divisor:Int):Int
		return Std.int(n / divisor);

	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else js.Syntax.code("parseInt({0})", s); #end

	@:pure public static inline function atof(s:String):Float
		return Std.parseFloat(s);

	@:pure public static inline function ctoa(characterCode:Int):String
		return String.fromCharCode(characterCode);

	@:pure public static inline function compareString(a:String, b:String):Int
		return if (a < b) -1 else if (b < a) 1 else 0;
}
