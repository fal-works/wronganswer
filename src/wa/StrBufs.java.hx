package wa;

import wa.StrBuf;

class StrBufs {
	public static inline function int64(buf:StrBuf, v:haxe.Int64):StrBuf
		return @:privateAccess buf.builder().append(v);

	public static inline function float(buf:StrBuf, v:Float):StrBuf
		return @:privateAccess buf.builder().append(v);

	public static inline function floatWithScale(buf:StrBuf, v:Float, scale:Int):StrBuf {
		if (v < 0) {
			buf.char("-".code);
			v = -v;
		}
		v += Math.pow(10.0, -scale) / 2.0;

		int64(buf, cast(v, haxe.Int64));
		if (scale != 0) {
			buf.char(".".code);
			v -= cast(cast(v, haxe.Int64), Float);

			for (i in 0...scale) {
				v *= 10.0;
				buf.int(((cast v) : Int));
				v -= Std.int(v);
			}
		}

		return buf;
	}

	public static inline function int64Vec(buf:StrBuf, vec:haxe.ds.Vector<haxe.Int64>, separator:Int, delimiterString:String):StrBuf {
		int64(buf, vec[0]);
		for (i in 1...vec.length) {
			buf.char(separator);
			int64(buf, vec[i]);
		}
		buf.str(delimiterString);
		return buf;
	}

	public static inline function floatVec(buf:StrBuf, vec:haxe.ds.Vector<Float>, separator:Int, delimiterString:String):StrBuf {
		float(buf, vec[0]);
		for (i in 1...vec.length) {
			buf.char(separator);
			float(buf, vec[i]);
		}
		buf.str(delimiterString);
		return buf;
	}

	public static inline function floatVecWithScale(buf:StrBuf, vec:haxe.ds.Vector<Float>, scale:Int, separator:Int, delimiterString:String):StrBuf {
		floatWithScale(buf, vec[0], scale);
		for (i in 1...vec.length) {
			buf.char(separator);
			floatWithScale(buf, vec[i], scale);
		}
		buf.str(delimiterString);
		return buf;
	}
}
