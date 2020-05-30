package wa;

import wa.Vec;

/**
	Utility static functions for `Vec`.
**/
class Vecs {
	/**
		Internal stack for recursion in `quicksort()`.
	**/
	static var quicksortStack = new Vec<Int>(64);

	/**
		Creates a vector of elements returned from `factory()` callback.

		Note:
		- It first allocates an array with `length` and then assigns values.
		  On JS target there might be some tradeoffs here.
		- On Java target, `Vector` cannot be directly converted to `String`.
	**/
	@:generic @:noUsing
	public static inline function create<T>(length:Int, factory:(index:Int) -> T):Vec<T> {
		final vec = new Vec<T>(length);
		for (i in 0...length)
			vec[i] = factory(i);
		return vec;
	}

	/**
		@return An empty vector with `length`.
	**/
	@:generic @:noUsing
	public static inline function alloc<T>(length:Int):Vec<T>
		return new Vec<T>(length);

	/**
		@return The sum of all values in `vec`.
	**/
	public static inline function sum(vec:Vec<Int>):Int {
		var total = 0;
		for (i in 0...vec.length)
			total += vec[i];
		return total;
	}

	/**
		@return The sum of values in `vec` from index `start` until (but not including) `end`.
	**/
	public static inline function sumIn(vec:Vec<Int>, start:Int, end:Int):Int {
		#if debug
		if (start < 0 || vec.length < end)
			throw "Out of bounds.";
		#end
		var total = 0;
		for (i in start...end)
			total += vec[i];
		return total;
	}

	/**
		Creates a reversed vector. This does not change the original vector.
	**/
	@:generic
	public static inline function reverse<T>(vec:Vec<T>):Vec<T> {
		final length = vec.length;
		final newVec = new Vec<T>(length);
		final lastIndex = length - 1;
		for (i in 0...length)
			newVec[i] = vec[lastIndex - i];
		return newVec;
	}

	/**
		Sets the stack capacity for recursion in `quicksort()`.
		The capacity required is twice the depth of the recurrence.
	**/
	public static inline function quicksortStackCapacity(capacity:Int):Void {
		quicksortStack = new Vec<Int>(capacity);
	}

	/**
		Sorts elements in `vec`.
		@param stackCapacity If specified, also calls `quicksortStackCapacity()`.
	**/
	@:generic
	public static inline function quicksort<T>(vec:Vec<T>, compare:T->T->Int, stackCapacity:Int = 0):Void {
		if (stackCapacity > quicksortStack.length)
			quicksortStackCapacity(stackCapacity);

		final stack = quicksortStack;
		var stackSize = 0;

		inline function push(lowIndex:Int, highIndex:Int):Void {
			stack[stackSize++] = lowIndex;
			stack[stackSize++] = highIndex;
		}
		inline function pop():Int
			return stack[--stackSize];

		inline function leftIsLess(left:T, right:T):Bool
			return compare(left, right) < 0;

		push(0, vec.length - 1);

		while (stackSize != 0) {
			final maxIndex = pop();
			final minIndex = pop();
			final pivot = vec[(minIndex + maxIndex) >> 1];

			var i = minIndex;
			var k = maxIndex;
			while (i <= k) {
				while (i < maxIndex && leftIsLess(vec[i], pivot))
					++i;
				while (minIndex < k && leftIsLess(pivot, vec[k]))
					--k;
				if (i <= k) {
					final tmp = vec[i];
					vec[i++] = vec[k];
					vec[k--] = tmp;
				}
			}

			if (minIndex < k)
				push(minIndex, k);
			if (i < maxIndex)
				push(i, maxIndex);
		}
	}

	/**
		Removes consecutive repeated elements in `vec` (compared with `==`)
		and assigns the deduplicated elements to `out` (top-aligned).

		E.g. `vec: [0, 1, 1, 2, 2, 3] => out: [0, 1, 2, 3, ...]`
		@return Number of elements after deduplicated.
	**/
	@:generic public static inline function dedup<T>(vec:Vec<T>, out:Vec<T>):Int {
		var last = vec[0];
		var writeIndex = 1;
		for (readIndex in 1...vec.length) {
			final current = vec[readIndex];
			if (current != last)
				out[writeIndex++] = current;
			last = current;
		}
		return writeIndex;
	}
}
