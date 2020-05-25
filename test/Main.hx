import haxe.Int64;
import haxe.Timer;
import wronganswer.Lib;

class Main {
	static function main() {
		// inputUnitTests();
		inputSpeed();
		outputUnitTests();
		// outputSpeed();
	}

	static function inputUnitTests() {
		Sys.println("\n[input unit tests]");
		final cin = new CharIn(32);
		Sys.println('count: ${cin.int(LF)}');
		Sys.println('string: ${cin.str(LF)}');
		Sys.println('float: ${cin.float(LF)}');
		Sys.println('zero: ${cin.int(SP)}');
		Sys.println('one: ${cin.int(LF)}');
	}

	static function inputSpeed() {
		Sys.println("\n[input speed]");
		Timer.measure(() -> {
			final cin = new CharIn(32);
			final count = cin.int(LF);
			Sys.println('count: $count');
			Sys.println('string: ${cin.str(LF)}');
			Sys.println('float: ${cin.float(LF)}');
			var lastNumber = 0;
			for (i in 0...count) {
				cin.int(SP);
				lastNumber = cin.int(LF);
			}
			Sys.println('last number: $lastNumber');
		});
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
		cout.flush();
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
			cout.flush();
		});
	}
}
