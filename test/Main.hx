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
		// final input = Sys.stdin();
		// // final a = input.readUntil(" ".code);
		// final a = input.readLine();
		// input.close();
	}

	static function inputSpeed() {
		Sys.println("\n[input speed]");
		Timer.measure(() -> {
			final stdin = Sys.stdin();
			final count = Std.parseInt(stdin.readLine());
			for (i in 0...count - 1) {
				stdin.readUntil(" ".code);
				stdin.readUntil("\n".code);
			}
			stdin.readUntil(" ".code);
			final lastNumber = stdin.readLine();
			trace("last number: " + lastNumber);
		});
	}

	static function outputUnitTests() {
		Sys.println("\n[output unit tests]");
		final stdout = new StdOut();
		stdout.int(10).space().int(20).lf();
		stdout.char("A".code).lf();
		stdout.float(1.5).lf();
		var int64Value:Int64 = 0;
		for (i in 0...1000)
			int64Value += 1000000000;
		stdout.int64(int64Value).lf();
		stdout.flush();
	}

	static function outputSpeed() {
		Sys.println("\n[output speed]");
		Timer.measure(() -> {
			final stdout = new StdOut();
			stdout.int(10000).lf();
			var i = 0;
			while (i < 20000) {
				stdout.int(i).space();
				++i;
				stdout.int(i).lf();
				++i;
			}
			stdout.flush();
		});
	}
}
