package wa;

import wa.StrBuf;
import wa.Printer;

/**
	Buffered character output based on `StrBuf`.

	Use `print()` or `println()` to output the buffered data.
**/
@:forward
abstract CharOut(StrBuf) from StrBuf to StrBuf {
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
		Printer.print(this.toString());

	/**
		Prints the buffered string with CR and/or LF.
	**/
	public inline function println():Void
		Printer.println(this.toString());
}
