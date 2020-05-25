import haxe.Int64;
import haxe.Timer;
import wronganswer.Lib;
import wronganswer.naive.Lib.CharIn as NaiveCharIn;

class Main {
	static final testCaseNo = 0;

	static function main() {
		Ut.debug("This is a debug message.");

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
			default:
		}
	}

	static function inputUnitTests() {
		Sys.println("\n[input unit tests]");
		final cin = new CharIn(32);
		Sys.println('count: ${cin.int()}');
		Sys.println('string: ${cin.str(LF)}');
		Sys.println('float: ${cin.float()}');
		Sys.println('zero: ${cin.int()}');
		Sys.println('one: ${cin.int()}');
	}

	static function inputSpeed() {
		Sys.println("\n[input speed]");
		Timer.measure(() -> {
			final cin = new CharIn(32);
			final count = cin.int();
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
		Sys.println('count: ${cin.line()}');
		Sys.println('string: ${cin.line()}');
		Sys.println('float: ${cin.line()}');
		Sys.println('line split: ${cin.lineSplitInt()}');
	}

	static function outputUnitTests() {
		Sys.println("\n[output unit tests]");
		final cout = new CharOut();
		cout.int(10).space().int(20).lf();
		cout.char("A".code).lf();
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
}
