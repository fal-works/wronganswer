package wa;

import wa.Char32;
import wa.StrBuf;
import wa.Vec;
import wa.Int64;

class StrBufs {
	public static inline function int64(buf:StrBuf, v:Int64):StrBuf
		return @:privateAccess buf.builder().append(v);

	public static inline function float(buf:StrBuf, v:Float):StrBuf
		return @:privateAccess buf.builder().append(v);

	public static inline function floatWithScale(buf:StrBuf, v:Float, scale:Int):StrBuf {
		if (v < 0) {
			buf.char("-".code);
			v = -v;
		}
		v += Math.pow(10.0, -scale) / 2.0;

		int64(buf, cast(v, Int64));
		if (scale != 0) {
			buf.char(".".code);
			v -= cast(cast(v, Int64), Float);

			for (i in 0...scale) {
				v *= 10.0;
				buf.int(((cast v) : Int));
				v -= Std.int(v);
			}
		}

		return buf;
	}

	public static inline function int64Vec(buf:StrBuf, vec:Vec<Int64>, separator:Char32):StrBuf {
		int64(buf, vec[0]);
		for (i in 1...vec.length) {
			buf.char(separator);
			int64(buf, vec[i]);
		}
		return buf;
	}

	public static inline function floatVec(buf:StrBuf, vec:Vec<Float>, separator:Char32):StrBuf {
		float(buf, vec[0]);
		for (i in 1...vec.length) {
			buf.char(separator);
			float(buf, vec[i]);
		}
		return buf;
	}

	public static inline function floatVecWithScale(buf:StrBuf, vec:Vec<Float>, scale:Int, separator:Char32):StrBuf {
		floatWithScale(buf, vec[0], scale);
		for (i in 1...vec.length) {
			buf.char(separator);
			floatWithScale(buf, vec[i], scale);
		}
		return buf;
	}
}
