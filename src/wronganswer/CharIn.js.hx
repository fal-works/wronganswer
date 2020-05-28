package wronganswer;

import wronganswer.Util;
import wronganswer.Delimiter;

abstract CharIn(#if macro Dynamic #else js.node.buffer.Buffer #end) {
	@:pure static inline function isNotWhiteSpace(characterCode:Int):Bool {
		return switch characterCode {
			case " ".code | "\t".code | "\n".code | "\r".code:
				false;
			default:
				true;
		}
	}

	public extern inline function new(bufferCapacity:Int)
		this = #if macro null; #else js.node.Buffer.alloc(1); #end

	public inline function byte():Int {
		#if !macro
		js.node.Fs.readSync(0, this, 0, 1, null);
		#end
		return this[0];
	}

	public inline function digit():Int
		return byte() - "0".code;

	public inline function char():String
		return String.fromCharCode(byte());

	public inline function token():String {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		while (isNotWhiteSpace(byte)) {
			result += String.fromCharCode(byte);
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			byte = this[0];
		}
		#end

		return result;
	}

	public inline function int():Int {
		var result = 0;
		var negative = false;
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		if (byte == "-".code) {
			negative = true;
			readSync(0, this, 0, 1, null);
			byte = this[0];
		}
		while (isNotWhiteSpace(byte)) {
			result = 10 * result + byte - "0".code;
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			byte = this[0];
		}
		#end

		return if (negative) -result else result;
	}

	public inline function float():Float
		return Util.atof(token());

	public inline function str(delimiter:Delimiter):String {
		var result = "";
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		while (byte != delimiter) {
			result += String.fromCharCode(byte);
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			byte = this[0];
		}
		#end

		return StringTools.rtrim(result);
	}

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

	public inline function uint():Int
		return uintWithRadix(10);

	public inline function binary():Int
		return uintWithRadix(2);

	public inline function count(characterCode:Int):Int {
		var foundCount = 0;
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		while (isNotWhiteSpace(byte)) {
			if (byte == characterCode)
				++foundCount;
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			final byte = this[0];
		}
		#end

		return foundCount;
	}

	inline function uintWithRadix(radix:Int):Int {
		var result = 0;
		#if !macro
		final readSync = js.node.Fs.readSync;
		readSync(0, this, 0, 1, null);
		var byte = this[0];
		while (isNotWhiteSpace(byte)) {
			result = radix * result + byte - "0".code;
			if (readSync(0, this, 0, 1, null) == 0)
				break;
			byte = this[0];
		}
		#end

		return result;
	}
}
