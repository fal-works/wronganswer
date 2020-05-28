package wronganswer;

class Ut {
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

	@:pure public static inline function idiv(n:Int, divisor:Int):Int
		return Std.int(n / divisor);

	@:pure public static inline function atoi(s:String):Int
		return #if macro 0; #else js.Syntax.code("parseInt({0})", s); #end

	@:pure public static inline function atof(s:String):Float
		return Std.parseFloat(s);

	@:pure public static inline function ctoa(characterCode:Int):String
		return String.fromCharCode(characterCode);

	@:pure public static inline function ftoa(v:Float, scale:Int):String {
		var result = if (v >= 0) "" else {
			v = -v;
			"-";
		};

		v += Math.pow(10.0, -scale) / 2.0;
		final integerPart = Std.int(v);

		if (scale != 0) {
			result += integerPart + ".";
			v -= integerPart;

			for (i in 0...scale) {
				v *= 10.0;
				final integerPart = Std.int(v);
				result += integerPart;
				v -= integerPart;
			}
		}

		return result;
	}

	@:pure public static inline function compareString(a:String, b:String):Int
		return if (a < b) -1 else if (a > b) 1 else 0;
}
