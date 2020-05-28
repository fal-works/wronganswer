package wronganswer;

import wronganswer.StrBuf;

/**
	Buffered character output based on `StrBuf`.

	Use `print()` or `println()` to output the buffered data.
**/
@:forward
abstract CharOut(StrBuf) {
	/**
		@param capacity Used on Java target.
	**/
	public inline function new(capacity = 1024) {
		this = new StrBuf(capacity);
	}

	/**
		Prints the buffered string.
	**/
	public inline function print():Void
		Sys.print(this.toString());

	/**
		Prints the buffered string with CR and/or LF.
	**/
	public inline function println():Void
		Sys.println(this.toString());
}