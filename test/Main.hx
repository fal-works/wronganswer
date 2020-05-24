import haxe.Int64;
import haxe.Timer;
import wronganswer.WrongAnswer;

class Main {
	static function main():Void {
		outputUnitTests();
		// outputSpeed();
	}

	static function testInput():Void {
		// final input = Sys.stdin();
		// // final a = input.readUntil(" ".code);
		// final a = input.readLine();
		// input.close();
	}

	static function outputUnitTests():Void {
		println("\n[output unit tests]");
		final out = new StdOut();
		out.int(10).space().int(20).lf();
		out.char("A".code).lf();
		out.float(1.5).lf();
		var int64Value: Int64 = 0;
		for (i in 0...1000) int64Value += 1000000000;
		out.int64(int64Value).lf();
		out.flush();
	}

	static function outputSpeed():Void {
		println("\n[output speed]");
		Timer.measure(() -> {
			final out = new StdOut();
			out.int(777);
			for (i in 0...10000) {
				out.int(i).lf();
			}
			out.flush();
		});
	}

	static function println(s:String): Void {
		#if js
		(untyped process).stdout.write(s + "\n");
		#else
		Sys.println(s);
		#end
	}
}
