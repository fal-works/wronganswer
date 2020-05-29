package wa;

import wa.StrBuf;

@:forward
abstract CharOut(StrBuf) from StrBuf to StrBuf {
	public inline function new() {
		this = new StrBuf();
	}

	public inline function print():Void {
		#if !macro
		js.Node.process.stdout.write(this.toString());
		#end
	}

	public inline function println():Void {
		#if !macro
		js.Node.process.stdout.write(this.toString());
		js.Node.process.stdout.write("\n");
		#end
	}
}
