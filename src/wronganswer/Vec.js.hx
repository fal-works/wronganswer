package wronganswer;

class Vec {
	static var quicksortStack = new haxe.ds.Vector<Int>(64);

	@:generic @:noUsing
	public static inline function create<T>(length:Int, factory:(index:Int) -> T):haxe.ds.Vector<T> {
		final vec = new haxe.ds.Vector<T>(length);
		for (i in 0...length)
			vec[i] = factory(i);
		return vec;
	}

	public static inline function quicksortStackCapacity(bytes:Int):Void {
		quicksortStack = new haxe.ds.Vector<Int>(bytes);
	}

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
}
