import tools.Statics.*;
import tools.Bundler;

class Run {
	static function main() {
		final args = Sys.args();

		if (args.length > 0) {
			if (args[0].toLowerCase() == Bundler.command) {
				Bundler.tryRun(args);
				return;
			}
		}

		showVersion();
	}

	static function showVersion()
		Sys.println('\n$libName $version\n$haxelibUrl\n');
}
