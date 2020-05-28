import haxe.Int64;
import haxe.Timer;
import wa.*;
import wa.naive.CharIn as NaiveCharIn;
import wa.naive.Delimiter;

class Main {
	static final testCaseNo = 5;

	static function main() {
		Util.println("Start test.");
		Debug.log("This is a debug message.");

		switch testCaseNo {
			case 0:
				inputUnitTests();
			case 1:
				inputSpeed();
			case 2:
				naiveInputUnitTests();
			case 3:
				outputUnitTests();
			case 4:
				outputSpeed();
			case 5:
				vec();
			case 6:
				extra();
			default:
		}
	}

	static function inputUnitTests() {
		Sys.println("\n[input unit tests]");
		final cin = new CharIn(32);
		Sys.println('count: ${cin.uint()}');
		Sys.println('string: ${cin.str(LF)}');
		Sys.println('float: ${cin.float()}');
		Sys.println('zero: ${cin.int()}');
		Sys.println('one: ${cin.int()}');
		Sys.println('two-five: ${cin.intVec(4).toArray()}');
	}

	static function inputSpeed() {
		Sys.println("\n[input speed]");
		Timer.measure(() -> {
			final cin = new CharIn(32);
			final count = cin.uint();
			Sys.println('count: $count');
			Sys.println('string: ${cin.str(LF)}');
			Sys.println('float: ${cin.float()}');
			var lastNumber = 0;
			for (i in 0...count) {
				cin.int();
				lastNumber = cin.int();
			}
			Sys.println('last number: $lastNumber');
		});
	}

	static function naiveInputUnitTests() {
		Sys.println("\n[naive input unit tests]");
		final cin = new NaiveCharIn();
		Sys.println('count: ${cin.int(LF)}');
		Sys.println('string: ${cin.str(LF)}');
		Sys.println('float: ${Std.parseFloat(cin.str(LF))}');
		Sys.println('zero: ${cin.int(SP)}');
		Sys.println('one: ${cin.int(LF)}');
	}

	static function outputUnitTests() {
		Sys.println("\n[output unit tests]");
		final cout = new CharOut();
		cout.int(10).space().int(20).lf();
		cout.char("A".code).lf();
		cout.str("AAA").lf();
		cout.float(1.5).lf();
		var int64Value:Int64 = 0;
		for (i in 0...1000)
			int64Value += 1000000000;
		cout.int64(int64Value).lf();
		cout.print();
	}

	static function outputSpeed() {
		Sys.println("\n[output speed]");
		Timer.measure(() -> {
			final cout = new CharOut();
			cout.int(10000).lf();
			var i = 0;
			while (i < 20000) {
				cout.int(i).space();
				++i;
				cout.int(i).lf();
				++i;
			}
			cout.print();
		});
	}

	static function vec() {
		Sys.println("\n[vec]");

		final vec = haxe.ds.Vector.fromArrayCopy([for (i in 0...10000) Std.int(100 * Math.random())]);
		Sys.println("sorting...");
		Timer.measure(() -> {
			Vec.quicksort(vec, (a, b) -> a - b);
		});
		Sys.println("first: " + vec[0]);
		Sys.println("last: " + vec[vec.length - 1]);

		Sys.println("");
		Sys.println("dedup...");
		final vec2 = haxe.ds.Vector.fromArrayCopy([0, 1, 1, 2, 2, 3]);
		final deduplicated = Vec.dedup(vec2, vec2);
		Sys.println(vec2.toArray());
		Sys.println(deduplicated + " elements after dedup.");
}

	static function extra() {
		Sys.println("\n[extra]");
		var bits:Bits = 0;
		bits = Bits.set(bits, 2);
		Sys.println(bits.toBoolVec(3).toArray()); // false, false, true
		bits.forEachBitReversed(flag -> Sys.print(flag ? "1" : "0"), 3); // 100
		Sys.println("");
		Sys.println('ones: ${bits.countOnes()}');
		Sys.println('trailing zeros: ${bits.trailingZeros()}');
		Sys.println('first bit: ${bits[0]}'); // false
	}
}
