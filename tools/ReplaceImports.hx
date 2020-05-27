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
		"Vec",
		"extra.Bits",
		"Debug"
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
		Removes the import statement for `module` from `code`
		and appends the actual source code of `module` instead.
	**/
	static function replaceImport(code:String, module:String) {
		final importRegExp = new EReg('import\\s+$module\\s*;', "i");
		final removed = importRegExp.replace(code, "");
		if (code.length == removed.length)
			return code;

		code = removed.trim() + "\n\n";

		final srcCode = readSrcCode(getSrcFilePath(module));
		Sys.println('Replacing: import $module;');

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
		@return the file path of the source code for `module`.
	**/
	static function getSrcFilePath(module:String) {
		final modulePath = module.replace(".", "/");
		var srcFilePath = FileSystem.absolutePath('$srcDirectory$modulePath$target.hx');

		if (!FileSystem.exists(srcFilePath))
			srcFilePath = FileSystem.absolutePath('$srcDirectory$modulePath.hx');

		if (!FileSystem.exists(srcFilePath))
			throw 'File not found for module: $module';

		return srcFilePath;
	}

	/**
		Reads The content of the source code file at `fullPath`,
		removing the package declaration.
	**/
	static function readSrcCode(fullPath:String) {
		var srcCode = readFile(fullPath);
		srcCode = RegExps.pkg.replace(srcCode, "");
		srcCode = RegExps.comment.replace(srcCode, "");
		return srcCode.trim() + "\n";
	}

	/**
		Creates a file with `content` at `fullPath`.
		Overwrites the file if it already exists.
	**/
	static function createFile(fullPath:String, content:String) {
		final newFile = File.write(fullPath, true);
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

class RegExps {
	/**
		Regular expression for matching any package declaration.
	**/
	public static final pkg = ~/package\s+.+\s*;/i;

	/**
		Regular expression for matching any multiline comment with double asterisks.
	**/
	public static final comment = ~/\/\*\*\n?[^\*]+\*\*\/\s*/gm;
}
