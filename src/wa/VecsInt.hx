package wa;

import wa.Vec;

/**
	Utility static functions for `Vec<Int>`.
**/
class VecsInt {
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
}
