package wronganswer;

import wronganswer.StringBuffer;

@:forward
abstract CharOut(StringBuffer) {
	public inline function new(capacity = 1024) {
		this = new StringBuffer(capacity);
	}

	public inline function print():Void {
		#if !macro
		java.lang.System.out.print(this.toString());
		#end
	}

	public inline function println():Void {
		#if !macro
		java.lang.System.out.println(this.toString());
		#end
	}
}
