package wa;

/**
	Printing functions.
**/
class Printer {
	/**
		Prints `x`.
		More optimized than `Sys.print()` on java/js targets.
	**/
	@:generic public static inline function print<T>(x:T):Void
		Sys.print(x);

	/**
		Prints `x` with line break.
		More optimized than `Sys.println()` on java/js targets.
	**/
	@:generic public static inline function println<T>(x:T):Void
		Sys.println(x);
}
