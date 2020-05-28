package wronganswer;

import wronganswer.StringBuffer;

class Ut {
	@:generic public static inline function print<T>(x:T):Void {
		#if !macro
		untyped __java__("java.lang.System.out.print({0});", x);
		#end
	}

	@:generic public static inline function println<T>(x:T):Void {
		#if !macro
		untyped __java__("java.lang.System.out.println({0});", x);
		#end
	}

	@:pure public static inline function idiv(n:Int, divisor:Int):Int
		return #if macro 0; #else untyped __java__("{0} / {1}", n, divisor); #end

	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else java.lang.Integer.parseInt(s, 10); #end

	@:pure public static inline function atof(s:String):Float
		return #if macro 0; #else java.lang.Double.DoubleClass.parseDouble(s); #end

	@:pure public static inline function ctoa(characterCode:Int):String
		return String.fromCharCode(characterCode);

	@:pure public static inline function ftoa(v:Float, scale:Int):String {
		final buffer = new StringBuffer(15 + scale);
		buffer.floatWithScale(v, scale);
		return buffer.toString();
	}
}
