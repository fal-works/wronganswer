package wa;

class Debug {
	/**
		Prints a debug log only `#if debug`, otherwise no effect/impact.
	**/
	@:noUsing public static macro function log(message:haxe.macro.Expr):haxe.macro.Expr {
		#if debug
		return macro Sys.println('[DEBUG] ' + Std.string($message));
		#else
		return macro null;
		#end
	}
}
