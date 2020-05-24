class Run {
	static function main() {
		#if sys
		final libraryName: String = "wronganswer";
		final version = haxe.macro.Compiler.getDefine("wronganswer");

		final url = 'https://lib.haxe.org/p/${libraryName}/';

		Sys.println('\n${libraryName} ${version}\n${url}\n');
		#end
	}
}
