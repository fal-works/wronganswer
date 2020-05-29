import haxe.Int64;
import haxe.Timer;
import wa.*;
import wa.naive.CharIn as NaiveCharIn;
import wa.Whitespace;
import wa.Printer.*;

using wa.CharIns;
using wa.CharOuts;
using wa.naive.CharIns;

class Main {
	static final testCaseNo = 3;

	static function main() {
		Printer.println("Start test.");
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
		println("\n[input unit tests]");
		final cin = new CharIn(32);
		println('count: ${cin.uint()}');
		println('string: ${cin.until(LF)}');
		println('float: ${cin.float()}');
		println('zero: ${cin.int()}');
		println('one: ${cin.int()}');
		println('two-five: ${cin.intVec(4).toArray()}');
	}

	static function inputSpeed() {
		println("\n[input speed]");
		Timer.measure(() -> {
			final cin = new CharIn(32);
			final count = cin.uint();
			println('count: $count');
			println('string: ${cin.until(LF)}');
			println('float: ${cin.float()}');
			var lastNumber = 0;
			for (i in 0...count) {
				cin.int();
				lastNumber = cin.int();
			}
			println('last number: $lastNumber');
		});
	}

	static function naiveInputUnitTests() {
		println("\n[naive input unit tests]");
		final cin = new NaiveCharIn();
		println('count: ${cin.int()}');
		println('string: ${cin.until(LF)}');
		println('float: ${Std.parseFloat(cin.str())}');
		println('zero: ${cin.int()}');
		println('one: ${cin.int()}');
	}

	static function outputUnitTests() {
		println("\n[output unit tests]");
		final cout = new CharOut();
		cout.int(10).space().int(20).lf();
		cout.char("A".code).lf();
		cout.str("AAA").lf();
		cout.float(1.5).lf();
		var int64Value:Int64 = 0;
		for (i in 0...1000)
			int64Value += 1000000000;
		cout.int64(int64Value).lf();
		cout.intVec(haxe.ds.Vector.fromArrayCopy([1,2,3]), SP);
		cout.print();
	}

	static function outputSpeed() {
		println("\n[output speed]");
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
		println("\n[vec]");

		final vec = haxe.ds.Vector.fromArrayCopy([for (i in 0...10000) Std.int(100 * Math.random())]);
		println("sorting...");
		Timer.measure(() -> {
			Vecs.quicksort(vec, (a, b) -> a - b);
		});
		println("first: " + vec[0]);
		println("last: " + vec[vec.length - 1]);

		println("");
		println("dedup...");
		final vec2 = haxe.ds.Vector.fromArrayCopy([0, 1, 1, 2, 2, 3]);
		final deduplicated = Vecs.dedup(vec2, vec2);
		println(vec2.toArray());
		println(deduplicated + " elements after dedup.");
}

	static function extra() {
		println("\n[extra]");
		var bits:Bits = 0;
		bits = Bits.set(bits, 2);
		println(bits.toBoolVec(3).toArray()); // false, false, true
		bits.forEachBitReversed(flag -> print(flag ? "1" : "0"), 3); // 100
		println("");
		println('ones: ${bits.countOnes()}');
		println('trailing zeros: ${bits.trailingZeros()}');
		println('first bit: ${bits[0]}'); // false
	}
}
