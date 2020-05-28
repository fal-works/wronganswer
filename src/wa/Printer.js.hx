package wa;

class Printer {
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
}
