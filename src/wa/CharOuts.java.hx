package wa;

class CharOuts {
	public static inline function int64(cout:CharOut, v:haxe.Int64):CharOut {
		@:privateAccess cout.internal().print(v);
		return cout;
	}

	public static inline function float(cout:CharOut, v:Float):CharOut {
		@:privateAccess cout.internal().print(v);
		return cout;
	}

	public static inline function floatWithScale(cout:CharOut, v:Float, scale:Int):CharOut {
		if (v < 0) {
			cout.char("-".code);
			v = -v;
		}
		v += Math.pow(10.0, -scale) / 2.0;

		int64(cout, cast(v, haxe.Int64));
		if (scale != 0) {
			cout.char(".".code);
			v -= cast(cast(v, haxe.Int64), Float);

			for (i in 0...scale) {
				v *= 10.0;
				cout.int(((cast v) : Int));
				v -= Std.int(v);
			}
		}

		return cout;
	}

	public static inline function int64Vec(cout:CharOut, vec:haxe.ds.Vector<haxe.Int64>, separator:Char32):CharOut {
		int64(cout, vec[0]);
		for (i in 1...vec.length) {
			cout.char(separator);
			int64(cout, vec[i]);
		}
		return cout;
	}

	public static inline function floatVec(cout:CharOut, vec:haxe.ds.Vector<Float>, separator:Char32):CharOut {
		float(cout, vec[0]);
		for (i in 1...vec.length) {
			cout.char(separator);
			float(cout, vec[i]);
		}
		return cout;
	}

	public static inline function floatVecWithScale(cout:CharOut, vec:haxe.ds.Vector<Float>, scale:Int, separator:Char32):CharOut {
		floatWithScale(cout, vec[0], scale);
		for (i in 1...vec.length) {
			cout.char(separator);
			floatWithScale(cout, vec[i], scale);
		}
		return cout;
	}
}
