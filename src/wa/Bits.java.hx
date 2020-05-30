package wa;

import wa.Vec;

abstract Bits(Int) from Int to Int {
	public static inline function from(v:Int):Bits
		return v;

	@:op(A << B) static function leftShift(bits:Bits, shiftCount:Int):Bits;

	@:op(A >> B) static function rightShift(bits:Bits, shiftCount:Int):Bits;

	@:op(A >>> B) static function unsignedRightShift(bits:Bits, shiftCount:Int):Bits;

	@:op(A == B) static function equal(a:Bits, b:Bits):Bool;

	@:op(A != B) static function notEqual(a:Bits, b:Bits):Bool;

	@:op(A & B) static function and(a:Bits, b:Bits):Bits;

	@:op(A | B) static function or(a:Bits, b:Bits):Bits;

	@:op(A ^ B) static function xor(a:Bits, b:Bits):Bits;

	@:op(~A) static function negate(a:Bits):Bits;

	public static inline function set(bits:Bits, index:Int):Bits {
		return bits | (1 << index);
	}

	public static inline function unset(bits:Bits, index:Int):Bits {
		return bits & ~(1 << index);
	}

	@:op([]) public inline function get(index:Int):Bool {
		return this & (1 << index) != 0;
	}

	public inline function countOnes():Int
		return #if macro 0; #else java.lang.Integer.bitCount(this); #end

	public inline function trailingZeros():Int
		return #if macro 0; #else java.lang.Integer.numberOfTrailingZeros(this); #end

	public inline function trailingOnes():Int
		return #if macro 0; #else java.lang.Integer.numberOfTrailingZeros(~this); #end

	public inline function toBoolVec(length:Int):Vec<Bool> {
		final vec = new Vec(length);
		var bitMask = 1;
		for (i in 0...length) {
			vec[i] = this & bitMask != 0;
			bitMask <<= 1;
		}
		return vec;
	}

	public inline function forEachBit(callback:(flag:Bool) -> Void, length:Int):Void {
		var bitMask = 1;
		for (i in 0...length) {
			callback(this & bitMask != 0);
			bitMask <<= 1;
		}
	}

	public inline function forEachBitReversed(callback:(flag:Bool) -> Void, length:Int):Void {
		var bitMask = 1 << (length - 1);
		for (i in 0...length) {
			callback(this & bitMask != 0);
			bitMask >>>= 1;
		}
	}
}
