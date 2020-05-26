package tools;

import sys.FileSystem;
import sys.io.File;
import tools.Statics.*;

using StringTools;

/**
	Target platform supported by wronganswer.
**/
enum abstract Target(String) {
	final Java = ".java";
	final Js = ".js";
	final Eval = "";
}

class ReplaceImports {
	/**
		Modules to be replaced.
	**/
	static final importableModules = [
		"Lib",
		"naive.Lib",
		"extra.Bits"
	].map(s -> '$libName.$s');

	/**
		The banner comment to be inserted when replacing.
	**/
	static inline final bannerComment = '\n/**\n\t$libName v$version / CC0\n\t$repositoryUrl\n**/\n\n';

	/**
		The command name.
	**/
	static inline final command = "replace-imports";

	/**
		The directory path of the source code of wronganswer.
	**/
	static final srcDirectory = FileSystem.absolutePath("src") + "/";

	/**
		The target platform.
	**/
	static var target:Target = Eval;

	/**
		`true` if any part of code has been replaced.
	**/
	static var replaced = false;

	/**
		Validates `args` and then calls `run()`.
	**/
	public static function tryRun(args:Array<String>) {
		if (args.length < 3) {
			showInstruction();
			return;
		}

		final filePath = args[1];

		if (!FileSystem.exists(filePath)) {
			Sys.println('File not found: $filePath');
			showInstruction();
			return;
		}

		final targetString = args[2];

		switch targetString.toLowerCase() {
			case "java":
				target = Java;
			case "js":
				target = Js;
			case "eval":
				target = Eval;
			default:
				Sys.println('Unsupported target: $targetString');
				showInstruction();
				return;
		}

		run(filePath);

		return;
	}

	/**
		Replaces import statements in the code at `filePath`
		and writes the result to a new file.
	**/
	static function run(filePath:String) {
		final replacedCode = replaceAll(readFile(filePath));

		if (!replaced) {
			Sys.println("Found no statements to be replaced.");
			return;
		}

		createFile(filePath + ".replaced", replacedCode);
		Sys.println("Completed.");
	}

	/**
		Replaces all import statements in `code`.
	**/
	static function replaceAll(code:String) {
		for (module in importableModules)
			code = replaceImport(code, module);

		return code;
	}

	/**
		Replaces the import statement in `code` by the actual source code of `module`.
	**/
	static function replaceImport(code:String, module:String) {
		final importStatement = 'import $module;';
		if (!code.contains(importStatement))
			return code;

		code = code.replace(importStatement + "\n", "");

		if (code.charCodeAt(code.length - 1) == "\n".code)
			code += "\n";

		final modulePath = module.replace(".", "/");
		var srcFilePath = FileSystem.absolutePath('$srcDirectory$modulePath$target.hx');
		if (!FileSystem.exists(srcFilePath))
			srcFilePath = FileSystem.absolutePath('$srcDirectory$modulePath.hx');
		if (!FileSystem.exists(srcFilePath))
			throw 'File not found for module: $module';

		var srcCode = readFile(srcFilePath);
		srcCode = srcCode.substr(srcCode.indexOf("\n") + 2); // remove first line and the next LF

		Sys.println('Replacing: $importStatement');

		if (!replaced)
			code += bannerComment;

		code += srcCode;
		replaced = true;

		return code;
	}

	/**
		Shows instruction about the replacing command.
	**/
	static function showInstruction()
		Sys.println('\ncommand:\n  haxelib run $libName $command [full file path] [target (java/js/eval)]\n');

	/**
		@return the content of the file at `fullPath`.
	**/
	static function readFile(fullPath:String) {
		final file = File.read(fullPath, false);
		var content:String;
		try {
			content = file.readAll().toString();
		} catch (e:Dynamic) {
			Sys.println('Error while reading file: $fullPath');
			file.close();
			throw e;
		}
		file.close();
		return content;
	}

	/**
		Creates a file with `content` at `fullPath`.
		Overwrites the file if it already exists.
	**/
	static function createFile(fullPath:String, content:String) {
		final newFile = File.write(fullPath, false);
		try {
			newFile.writeString(content, UTF8);
		} catch (e:Dynamic) {
			Sys.println('Error while creating file: $fullPath');
			newFile.close();
			throw e;
		}
		newFile.close();
	}
}
