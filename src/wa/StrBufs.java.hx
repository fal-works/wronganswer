package wa;

import wa.StrBuf;

class StrBufs {
	public static inline function floatWithScale(buf:StrBuf, v:Float, scale:Int):StrBuf {
		if (v < 0) {
			buf.char("-".code);
			v = -v;
		}
		v += Math.pow(10.0, -scale) / 2.0;

		buf.int64(cast(v, haxe.Int64));
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
}
