import tools.Statics.*;

class Run {
	static function main() {
		final args = Sys.args();

		if (args.length > 0) {
			if (args[0].toLowerCase() == "replace-imports") {
				tools.ReplaceImports.tryRun(args);
				return;
			}
		}

		showVersion();
	}

	static function showVersion()
		Sys.println('\n$libName $version\n$haxelibUrl\n');
}
