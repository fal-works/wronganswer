package wa;

import wa.StrBuf;

@:forward
abstract CharOut(StrBuf) to StrBuf {
	public inline function new(capacity = 1024) {
		this = new StrBuf(capacity);
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
