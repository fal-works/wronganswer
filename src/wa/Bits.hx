package wa;

/**
	Bit array based on `Int`.
**/
abstract Bits(Int) from Int to Int {
	/**
		Casts from `Int` explicitly.
	**/
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

	/**
		Sets the bit at `index`.
		@return New `Bits` value.
	**/
	public static inline function set(bits:Bits, index:Int):Bits {
		return bits | (1 << index);
	}

	/**
		Unsets the bit at `index`.
		@return New `Bits` value.
	**/
	public static inline function unset(bits:Bits, index:Int):Bits {
		return bits & ~(1 << index);
	}

	/**
		@return `true` if the bit at `index` is set.
	**/
	@:op([]) public inline function get(index:Int):Bool {
		return this & (1 << index) != 0;
	}

	/**
		@return Number of bits that are set to `true` (or binary `1`).
	**/
	public inline function countOnes():Int {
		var n = this;
		n = n - ((n >>> 1) & 0x55555555);
		n = (n & 0x33333333) + ((n >>> 2) & 0x33333333);
		n = (((n + (n >>> 4)) & 0x0F0F0F0F) * 0x01010101) >>> 24;
		return n;
	}

	/**
		@return Number of trailing `0`.
	**/
	public inline function trailingZeros():Int {
		var n = this;
		var count = 0;
		while (n & 1 == 0) {
			++count;
			n >>>= 1;
		}
		return count;
	}

	/**
		@return Number of trailing `1`.
	**/
	public inline function trailingOnes():Int {
		var n = this;
		var count = 0;
		while (n & 1 != 0) {
			++count;
			n >>>= 1;
		}
		return count;
	}

	/**
		Converts `this` to a vector of `Bool` values.
	**/
	public inline function toBoolVec(length:Int):haxe.ds.Vector<Bool> {
		final vec = new haxe.ds.Vector(length);
		var bitMask = 1;
		for (i in 0...length) {
			vec[i] = this & bitMask != 0;
			bitMask <<= 1;
		}
		return vec;
	}

	/**
		Runs `callback` for each bit (either `true` or `false`).
	**/
	public inline function forEachBit(callback:(flag:Bool) -> Void, length:Int):Void {
		var bitMask = 1;
		for (i in 0...length) {
			callback(this & bitMask != 0);
			bitMask <<= 1;
		}
	}

	/**
		Runs `callback` for each bit (either `true` or `false`)
		in reversed order i.e. from left to right in a string representation.
	**/
	public inline function forEachBitReversed(callback:(flag:Bool) -> Void, length:Int):Void {
		var bitMask = 1 << (length - 1);
		for (i in 0...length) {
			callback(this & bitMask != 0);
			bitMask >>>= 1;
		}
	}
}
