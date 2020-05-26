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

	static function showVersion() {
		final libraryName: String = "wronganswer";
		final version = haxe.macro.Compiler.getDefine("wronganswer");

		final url = 'https://lib.haxe.org/p/${libraryName}/';

		Sys.println('\n${libraryName} ${version}\n${url}\n');
	}
}
