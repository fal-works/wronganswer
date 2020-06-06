package wa;

class Printer {
	@:generic public static inline function print<T>(x:T):Void {
		#if !macro
		js.Syntax.code('process.stdout.write("" + {0});', x);
		#end
	}

	@:generic public static inline function println<T>(x:T):Void {
		#if !macro
		print(x);
		js.Node.process.stdout.write("\n");
		#end
	}
}
