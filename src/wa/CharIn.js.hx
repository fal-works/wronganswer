package wa;

import wa.Char32;

abstract CharIn(#if macro Dynamic #else js.node.buffer.Buffer #end) {
	public extern inline function new(bufferCapacity:Int)
		this = #if macro null; #else js.node.Buffer.alloc(bufferCapacity); #end

	public inline function char():Char32 {
		#if !macro
		js.node.Fs.readSync(0, this, 0, 1, null);
		#end
		return this[0];
	}

	public inline function str():String {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		try {
			readSync(0, this, 0, 1, null);
			var character:Char32 = this[0];
			while (character.isNotWhiteSpace()) {
				result += character.toString();
				if (readSync(0, this, 0, 1, null) == 0)
					break;
				character = this[0];
			}
		} catch (e:Dynamic) {}
		#end

		return result;
	}

	public inline function int():Int {
		var result = 0;
		var negative = false;
		#if !macro
		final readSync = js.node.Fs.readSync;
		try {
			readSync(0, this, 0, 1, null);
			var character:Char32 = this[0];
			if (character == "-".code) {
				negative = true;
				readSync(0, this, 0, 1, null);
				character = this[0];
			}
			while (character.isNotWhiteSpace()) {
				result = 10 * result + character.toDigit();
				if (readSync(0, this, 0, 1, null) == 0)
					break;
				character = this[0];
			}
		} catch (e:Dynamic) {}
		#end

		return if (negative) -result else result;
	}

	public inline function uint():Int
		return uintWithRadix(10);

	public inline function strVec(length:Int):haxe.ds.Vector<String> {
		final vec = new haxe.ds.Vector<String>(length);
		for (i in 0...length)
			vec[i] = str();
		return vec;
	}

	public inline function intVec(length:Int):haxe.ds.Vector<Int> {
		final vec = new haxe.ds.Vector<Int>(length);
		for (i in 0...length)
			vec[i] = int();
		return vec;
	}

	public inline function uintVec(length:Int):haxe.ds.Vector<Int> {
		final vec = new haxe.ds.Vector<Int>(length);
		for (i in 0...length)
			vec[i] = uint();
		return vec;
	}

	inline function uintWithRadix(radix:Int):Int {
		var result = 0;
		#if !macro
		final readSync = js.node.Fs.readSync;
		try {
			readSync(0, this, 0, 1, null);
			var character:Char32 = this[0];
			while (character.isNotWhiteSpace()) {
				result = radix * result + character.toDigit();
				if (readSync(0, this, 0, 1, null) == 0)
					break;
				character = this[0];
			}
		} catch (e:Dynamic) {}
		#end

		return result;
	}

	inline function buffer()
		return this;
}
