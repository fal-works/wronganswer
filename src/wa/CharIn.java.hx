package wa;

import wa.Util;
import wa.StrBuf;
import wa.Delimiter;

abstract CharIn(haxe.io.Input) {
	static var byteArray:#if macro Dynamic; #else java.NativeArray<java.types.Int8>; #end

	@:pure static inline function isNotWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				false;
			default:
				true;
		}
	}

	public extern inline function new(bufferCapacity:Int) {
		this = Sys.stdin();
		#if !macro
		byteArray = new java.NativeArray(bufferCapacity);
		#end
	}

	public inline function byte():Int
		return this.readByte();

	public inline function digit():Int
		return byte() - "0".code;

	public inline function char():String
		return String.fromCharCode(byte());

	public inline function token():String {
		final byteArray = CharIn.byteArray;
		var index = 0;

		try {
			var byte = this.readByte();
			while (isNotWhiteSpace(byte)) {
				byteArray[index] = byte;
				++index;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		try {
			return #if macro ""; #else new String(byteArray, 0, index, "UTF-8"); #end
		} catch (e:Dynamic) {
			throw e;
		}
	}

	public inline function int():Int {
		var result = 0;
		var negative = false;
		try {
			var byte = this.readByte();
			if (byte == '-'.code) {
				negative = true;
				byte = this.readByte();
			}
			while (isNotWhiteSpace(byte)) {
				result = 10 * result + byte - "0".code;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return if (negative) -result else result;
	}

	public inline function float():Float
		return Util.atof(token());

	public inline function tokenVec(length:Int):haxe.ds.Vector<String> {
		final vec = new haxe.ds.Vector<String>(length);
		for (i in 0...length)
			vec[i] = token();
		return vec;
	}

	public inline function intVec(length:Int):haxe.ds.Vector<Int> {
		final vec = new haxe.ds.Vector<Int>(length);
		for (i in 0...length)
			vec[i] = int();
		return vec;
	}

	public inline function floatVec(length:Int):haxe.ds.Vector<Float> {
		final vec = new haxe.ds.Vector<Float>(length);
		for (i in 0...length)
			vec[i] = float();
		return vec;
	}

	public inline function str(delimiter:Delimiter):String {
		final byteArray = CharIn.byteArray;
		var index = 0;

		try {
			var byte = this.readByte();
			while (byte != delimiter) {
				byteArray[index] = byte;
				++index;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		try {
			return #if macro ""; #else new String(byteArray, 0, index, "UTF-8"); #end
		} catch (e:Dynamic) {
			throw e;
		}
	}

	public inline function uint():Int
		return uintWithRadix(10);

	public inline function binary():Int
		return uintWithRadix(2);

	public inline function count(characterCode:Int):Int {
		var foundCount = 0;
		try {
			var byte = this.readByte();
			while (isNotWhiteSpace(byte)) {
				if (byte == characterCode)
					++foundCount;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return foundCount;
	}

	inline function uintWithRadix(radix:Int):Int {
		var result = 0;
		try {
			var byte = this.readByte();
			while (isNotWhiteSpace(byte)) {
				result = radix * result + byte - "0".code;
				byte = this.readByte();
			}
		} catch (e:haxe.io.Eof) {}

		return result;
	}
}
