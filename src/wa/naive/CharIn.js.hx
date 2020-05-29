package wa.naive;

import wa.Char32;

abstract CharIn(#if macro Null<Dynamic> #else js.node.buffer.Buffer #end) {
	public extern inline function new()
		this = #if macro cast null; #else js.node.Buffer.alloc(1); #end

	public inline function char():Char32 {
		#if !macro
		js.node.Fs.readSync(0, this, 0, 1, null);
		#end
		return this[0];
	}

	public inline function str() {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var character:Char32 = this[0];
		while (character.isNotWhiteSpace()) {
			result += character.toString();
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			character = this[0];
		}
		#end
		return result;
	}

	public inline function int():Int
		return Std.parseInt(str());

	inline function buffer()
		return this;
}
