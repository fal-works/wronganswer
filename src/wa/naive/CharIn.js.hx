package wa.naive;

abstract CharIn(#if macro Null<Dynamic> #else js.node.buffer.Buffer #end) {
	public extern inline function new()
		this = #if macro cast null; #else js.node.Buffer.alloc(1); #end

	public inline function byte() {
		#if !macro
		js.node.Fs.readSync(0, this, 0, 1, null);
		#end
		return this[0];
	}

	public inline function char():Char
		return byte();

	public inline function str(delimiter:Char) {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var character:Char = this[0];
		while (character != delimiter) {
			result += character.toString();
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			character = this[0];
		}
		#end
		return result;
	}

	public inline function int(delimiter:Char):Int
		return Std.parseInt(str(delimiter));
}
