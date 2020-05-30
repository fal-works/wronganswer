package wa;

import wa.CharIn;
import wa.Vec;
import wa.Floats;

class CharInsFloat {
	public static inline function float(cin:CharIn):Float
		return Floats.atof(cin.str());

	public static inline function floatVec(cin:CharIn, length:Int):Vec<Float> {
		final vec = new Vec<Float>(length);
		for (i in 0...length)
			vec[i] = float(cin);
		return vec;
	}
}
