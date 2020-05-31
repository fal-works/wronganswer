package wa;

import wa.Vec;

/**
	Utility static functions for sorting elements in `Vec`.
**/
class VecsSort {
	/**
		Internal stack for recursion in `quicksort()`.
	**/
	static var recursionStack = new Vec<Int>(64);

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
	@:noUsing
	public static inline function stackCapacity(capacity:Int):Void {
		recursionStack = new Vec<Int>(capacity);
	}

	/**
		Sorts elements in `vec`.
		@param stackCapacity If specified, also calls `stackCapacity()`.
	**/
	@:generic
	public static inline function quicksort<T>(vec:Vec<T>, compare:T->T->Int, stackCapacity:Int = 0):Void {
		if (stackCapacity > recursionStack.length)
			VecsSort.stackCapacity(stackCapacity);

		final stack = recursionStack;
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

		If `vec` is sorted, all duplicates are removed.

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
