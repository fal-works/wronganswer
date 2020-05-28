package wa;

class Vec {
	/**
		Internal stack for recursion in `quicksort()`.
	**/
	static var quicksortStack = new haxe.ds.Vector<Int>(64);

	/**
		Creates a vector of elements returned from `factory()` callback.

		Note:
		- It first allocates an array with `length` and then assigns values.
		  On JS target there might be some tradeoffs here.
		- On Java target, `Vector` cannot be directly converted to `String`.
	**/
	@:generic @:noUsing
	public static inline function create<T>(length:Int, factory:(index:Int) -> T):haxe.ds.Vector<T> {
		final vec = new haxe.ds.Vector<T>(length);
		for (i in 0...length)
			vec[i] = factory(i);
		return vec;
	}

	/**
		Sets the stack capacity for recursion in `quicksort()`.
		The capacity required is twice the depth of the recurrence.
	**/
	public static inline function quicksortStackCapacity(capacity:Int):Void {
		quicksortStack = new haxe.ds.Vector<Int>(capacity);
	}

	/**
		Sorts elements in `vec`.
		@param stackCapacity If specified, also calls `quicksortStackCapacity()`.
	**/
	@:generic
	public static inline function quicksort<T>(vec:haxe.ds.Vector<T>, compare:T->T->Int, stackCapacity:Int = 0):Void {
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
	@:generic public static inline function dedup<T>(vec:haxe.ds.Vector<T>, out:haxe.ds.Vector<T>):Int {
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
