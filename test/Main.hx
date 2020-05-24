import haxe.Int64;
import haxe.Timer;
import wronganswer.WrongAnswer;

class Main {
	static function main() {
		// inputUnitTests();
		inputSpeed();
		// outputUnitTests();
		// outputSpeed();
	}

	static function inputUnitTests() {
		final cin = new CharIn(32);
		Sys.println(cin.int(LF));
		cin.close();
	}

	static function inputSpeed() {
		Sys.println("\n[input speed]");
		Timer.measure(() -> {
			final cin = new CharIn(32);
			final count = cin.int(LF);
			Sys.println('count: $count');
			var lastNumber = 0;
			for (i in 0...count) {
				cin.int(SP);
				lastNumber = cin.int(LF);
			}
			Sys.println('last number: $lastNumber');
			cin.close();
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
