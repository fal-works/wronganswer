package tools;

import sys.FileSystem;
import sys.io.File;
import tools.Statics.*;

using StringTools;

class ReplaceImports {
	/**
		Modules to be replaced.
	**/
	static final importableModules:Map<String, ModuleDescription> = [
		'$libName.*' => {
			priority: 0,
			wildcard: ["CharIn", "CharOut", "Delimiter", "Ut", "StringBuffer", "Vec", "Bits", "Debug"]
		},
		'$libName.naive.*' => {
			priority: 0,
			wildcard: ["CharIn", "Delimiter"]
		},
		'$libName.CharIn' => {priority: 0},
		'$libName.naive.CharIn' => {priority: 0},
		'$libName.CharOut' => {priority: 1},
		'$libName.Delimiter' => {priority: 2},
		'$libName.naive.Delimiter' => {priority: 2},
		'$libName.Ut' => {priority: 10},
		'$libName.StringBuffer' => {priority: 11},
		'$libName.Vec' => {priority: 12},
		'$libName.Bits' => {priority: 13},
		'$libName.Debug' => {priority: 100}
	];

	/**
		The banner comment to be inserted when replacing.
	**/
	static inline final bannerComment = '/**\n\t$libName v$version / CC0\n\t$repositoryUrl\n**/';

	/**
		The command name.
	**/
	static inline final command = "replace-imports";

	/**
		The directory path of the source code of wronganswer.
	**/
	static final srcDirectory = FileSystem.absolutePath("src") + "/";

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
		final target = switch targetString.toLowerCase() {
			case "java":
				Java;
			case "js":
				Js;
			case "eval":
				Eval;
			default:
				Sys.println('Unsupported target: $targetString');
				showInstruction();
				return;
		}

		run(filePath, target);
	}

	/**
		Replaces import statements in the code at `mainFilePath`
		and writes the result to a new file.
	**/
	static function run(mainFilePath:String, target:Target) {
		final mainCode = readFile(mainFilePath);

		final buffer:CodeBuffer = {codeBlocks: [], modules: []};
		final processedMainCode = processCode(mainCode, buffer, target, true).trim();

		final bundlingCode = buildFromBuffer(buffer);
		if (bundlingCode.length == 0) {
			Sys.println("Found no code to be replaced.");
			return;
		}

		final resultCode = '$processedMainCode\n\n\n$bundlingCode\n';
		final newFilePath = mainFilePath + ".replaced";
		createFile(newFilePath, resultCode);
		Sys.println('Create file: $newFilePath');
		Sys.println("Completed.");
	}

	/**
		Calls `processImport()` for each wronganswer-related import statement in `code`.
		@return `code` with the import statements removed.
	**/
	static function processCode(code:String, buffer:CodeBuffer, target:Target, main:Bool) {
		var currentPosition = 0;
		while (RegExps.importer.matchSub(code, currentPosition)) {
			final module = RegExps.importer.matched(1);

			if (importableModules.exists(module)) {
				code = processImport(code, module, buffer, target, main);
			} else {
				final matchedPos = RegExps.importer.matchedPos();
				currentPosition = matchedPos.pos + matchedPos.len;
			}
		}

		return code;
	}

	/**
		Removes the import statement for `module` from `code`
		and registers the code block of `module` for bundling.
	**/
	static function processImport(code:String, module:String, buffer:CodeBuffer, target:Target, main:Bool) {
		code = RegExps.importer.replace(code, "");

		final bundlingModules = buffer.modules;
		if (bundlingModules.exists(module)) // already registered
			return code;

		if (main)
			Sys.println('Replacing: import $module;');
		bundlingModules.set(module, true);

		final wildcard = importableModules.get(module).wildcard;
		if (wildcard != null) {
			final packagePath = module.substr(0, module.length - 1);
			for (moduleName in wildcard)
				code = processImport(code, packagePath + moduleName, buffer, target, false);
			return code;
		}

		final srcCode = readSrcCode(getSrcFilePath(module, target));
		final processedSrcCode = processCode(srcCode, buffer, target, false); // process recursively
		buffer.codeBlocks.push({
			code: processedSrcCode,
			priority: importableModules.get(module).priority
		});

		return code;
	}

	/**
		Sorts and joins all code blocks in `buffer` with a banner comment appended.
	**/
	static function buildFromBuffer(buffer:CodeBuffer) {
		final codeBlocks = buffer.codeBlocks;
		if (codeBlocks.length == 0)
			return "";

		codeBlocks.sort((blockA, blockB) -> blockA.priority - blockB.priority);
		final joinedCode = codeBlocks.map(block -> block.code.trim()).join("\n\n");

		return '$bannerComment\n\n$joinedCode';
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
	static function getSrcFilePath(module:String, target:Target) {
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

	/**
		Regular expression for matching any import statement.
		After matched, the module can be extracted by `importer.matched(1)`.
	**/
	public static final importer = new EReg('import\\s+(.+)\\s*;', "i");
}

/**
	Target platform supported by wronganswer.
**/
enum abstract Target(String) {
	final Java = ".java";
	final Js = ".js";
	final Eval = "";
}

/**
	Description for a wronganswer module.
**/
typedef ModuleDescription = {
	final priority:Int;
	final ?wildcard:Array<String>;
}

/**
	Stores code/modules to be bundled.
**/
typedef CodeBuffer = {
	final codeBlocks:Array<CodeBlock>;
	final modules:Map<String, Bool>;
};

/**
	Source code unit to be bundled.
**/
typedef CodeBlock = {
	final code:String;
	final priority:Int;
};
