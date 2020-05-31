package wa;

import wa.Vec;

/**
	Utility static functions for `Vec`.
**/
class Vecs {
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
		@return An empty 2-dimensional vector (actually array of arrays), of which elements can be accessed by `vec[row][column]`.
	**/
	@:generic @:noUsing
	public static inline function allocTable<T>(rows:Int, columns:Int):Vec<Vec<T>> {
		final table = new Vec<Vec<T>>(rows);
		for (row in 0...rows)
			table[row] = new Vec<T>(columns);
		return table;
	}

	/**
		@return A 2-dimensional vector with elements returned from `factory()`, which can be accessed by `vec[row][column]`.
	**/
	@:generic @:noUsing
	public static inline function createTable<T>(rows:Int, columns:Int, factory:(row:Int, column:Int)->T):Vec<Vec<T>> {
		final table = new Vec<Vec<T>>(rows);
		for (row in 0...rows) {
			final rowVec = new Vec<T>(columns);
			for (column in 0...columns)
				rowVec[column] = factory(row, column);
			table[row] = rowVec;
		}
		return table;
	}
}
