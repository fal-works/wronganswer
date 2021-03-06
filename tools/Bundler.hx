package tools;

import sys.io.File;
import tools.Statics.*;
import wa.Strs;
import locator.*;

using StringTools;

class Bundler {
	/**
		The command name.
	**/
	public static inline final command = "bundle";

	/**
		Modules that can be resolved.
	**/
	static final resolvableModules:Map<String, ModuleDescription> = [
		'$rootPackage.*' => {
			priority: 0,
			wildcard: [
				"CharIn", "CharIns", "CharInsInt64", "CharInsFloat", "CharOut", "CharOuts",
				"Char16", "Char32", "Whitespace", "Printer",
				"Ints", "Strs", "Floats", "Int64", "Int64s",
				"StrBuf", "StrBufs", "Vec", "Vecs", "VecsInt", "VecsSort", "Bits", "Debug"
			]
		},
		'$rootPackage.naive.*' => {
			priority: 0,
			wildcard: ["CharIn", "CharIns"]
		},
		'$rootPackage.CharIn' => {priority: 0},
		'$rootPackage.naive.CharIn' => {priority: 0},
		'$rootPackage.CharIns' => {priority: 1, usable: true},
		'$rootPackage.naive.CharIns' => {priority: 1, usable: true},
		'$rootPackage.CharInsInt64' => {priority: 2, usable: true},
		'$rootPackage.CharInsFloat' => {priority: 3, usable: true},
		'$rootPackage.CharOut' => {priority: 4},
		'$rootPackage.CharOuts' => {priority: 5, usable: true},
		'$rootPackage.Char16' => {priority: 10},
		'$rootPackage.Char32' => {priority: 11},
		'$rootPackage.Whitespace' => {priority: 12},
		'$rootPackage.Printer' => {priority: 13, usable: true},
		'$rootPackage.Ints' => {priority: 20, usable: true},
		'$rootPackage.Strs' => {priority: 21, usable: true},
		'$rootPackage.Floats' => {priority: 22, usable: true},
		'$rootPackage.Int64' => {priority: 23},
		'$rootPackage.Int64s' => {priority: 24, usable: true},
		'$rootPackage.StrBuf' => {priority: 30},
		'$rootPackage.StrBufs' => {priority: 31, usable: true},
		'$rootPackage.Vec' => {priority: 40},
		'$rootPackage.Vecs' => {priority: 41},
		'$rootPackage.VecsInt' => {priority: 42, usable: true},
		'$rootPackage.VecsSort' => {priority: 43, usable: true},
		'$rootPackage.Bits' => {priority: 50},
		'$rootPackage.Debug' => {priority: 100}
	];

	/**
		The banner comment to be inserted when replacing.
	**/
	static inline final bannerComment = '/**\n\t$libName v$version / CC0\n\t$repositoryUrl\n**/';

	/**
		The directory path of the source code of wronganswer.
	**/
	static final srcDirectory = DirectoryRef.from("src");

	/**
		If `true`, prints verbose logs.
	**/
	static var verbose = false;

	/**
		Validates `args` and then calls `run()`.
	**/
	public static function tryRun(args:Array<String>) {
		if (args.length < 3) {
			showInstruction();
			return;
		}

		if (1 < args.length && args[1] == "help") {
			showInstruction();
			showResolvableModules();
			return;
		}

		final file = FileRef.from(args[1]);

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

		verbose = args.length > 3 && args[3] == "verbose";

		run(file, target, verbose);
	}

	/**
		Replaces import statements in the code at `mainFile`
		and writes the result to a new file.
	**/
	static function run(mainFile:FileRef, target:Target, verbose:Bool) {
		final mainCode = RegExps.lineBreaks.replace(mainFile.getContent(), "\n");

		final buffer:CodeBuffer = {codeBlocks: [], modules: [], usingModules: []};
		final processedMainCode = processCode(mainCode, buffer, target, true);

		final mainModuleName = mainFile.path.getNameWithoutExtension();
		final resultCode = buildResultCode(mainModuleName, processedMainCode, buffer);
		if (resultCode.length == 0) {
			log("Found no code to be replaced.");
			return;
		}

		final newFilePath = mainFile.path.setExtension("bundle.hx");
		newFilePath.saveContent(resultCode);
		Sys.println('Create file: $newFilePath');
		log("Completed.");
	}

	/**
		Calls `processImport()` for each wronganswer-related import statement in `code`.
		@return `code` with the import statements removed.
	**/
	static function processCode(code:String, buffer:CodeBuffer, target:Target, main:Bool) {
		code = RegExps.commentedImportUsing.replace(code, "");

		var currentPosition = 0;
		while (RegExps.importer.matchSub(code, currentPosition)) {
			final module = RegExps.importer.matched(1);

			if (resolvableModules.exists(module)) {
				code = processImport(code, module, buffer, target, main);
			} else {
				final matchedPos = RegExps.importer.matchedPos();
				currentPosition = matchedPos.pos + matchedPos.len;
			}
		}

		currentPosition = 0;
		while (RegExps.user.matchSub(code, currentPosition)) {
			final module = RegExps.user.matched(1);

			if (resolvableModules.exists(module) && resolvableModules.get(module).usable) {
				code = processUsing(code, module, buffer, target, main);
			} else {
				final matchedPos = RegExps.user.matchedPos();
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

		if (main)
			log('Replacing: import $module;');

		final bundlingModules = buffer.modules;
		if (bundlingModules.exists(module)) // already registered
			return code;

		bundlingModules.set(module, true);

		final wildcard = resolvableModules.get(module).wildcard;
		if (wildcard != null) {
			final packagePath = module.substr(0, module.length - 1);
			for (moduleName in wildcard) {
				if (new EReg('\\W$moduleName\\W', "i").match(code))
					code = processImport(code, packagePath + moduleName, buffer, target, false);
			}
			return code;
		}

		final srcCode = readSrcCode(getSrcFile(module, target));
		final processedSrcCode = processCode(srcCode, buffer, target, false); // process recursively
		buffer.codeBlocks.push({
			code: processedSrcCode,
			priority: resolvableModules.get(module).priority
		});

		return code;
	}

	/**
		Removes the using statement for `module` from `code`
		and also calls `processImport()` if not yet called on `module`.
	**/
	static function processUsing(code:String, module:String, buffer:CodeBuffer, target:Target, main:Bool) {
		code = RegExps.user.replace(code, "");

		if (main)
			log('Replacing: using $module;');

		final usingModules = buffer.usingModules;
		if (usingModules.exists(module)) // already registered
			return code;

		usingModules.set(module, true);

		final bundlingModules = buffer.modules;
		if (!bundlingModules.exists(module))
			code = processImport(code, module, buffer, target, false);

		return code;
	}

	/**
		Build bundled code from `buffer` and `mainCode`.
		@param mainCode The main code with `import`/`using` statements removed.
	**/
	static function buildResultCode(mainModule:String, mainCode:String, buffer:CodeBuffer) {
		final usingCode = [
			for (module in buffer.usingModules.keys())
				module
		].map(module -> 'using $mainModule.${module.substr(module.indexOf(".") + 1)};').join("\n");

		final codeBlocks = buffer.codeBlocks;
		if (codeBlocks.length == 0)
			return "";

		codeBlocks.sort((blockA, blockB) -> blockA.priority - blockB.priority);
		final joinedCode = codeBlocks.map(block -> block.code.trim()).join("\n\n");

		return '$usingCode\n\n${mainCode.trim()}\n\n\n$bannerComment\n\n$joinedCode\n';
	}

	/**
		Shows instruction about the replacing command.
	**/
	static function showInstruction() {
		Sys.println('\ncommand:');
		Sys.println('  haxelib run $libName $command [full file path] [target (java/js/eval)]');
		Sys.println('  haxelib run $libName $command help');
		Sys.println("");
	}

	/**
		Shows a list of import statements that can be resolved.
	**/
	static function showResolvableModules() {
		// TODO: verbose mode, improve argument syntax

		Sys.println("statements that can be resolved:");

		final modules = [for (module in resolvableModules.keys()) module];
		modules.sort(Strs.compareString);
		for (module in modules)
			Sys.println('  import $module;');

		final usableModules = [
			for (module => desc in resolvableModules.keyValueIterator())
				if (desc.usable) module
		];
		usableModules.sort(Strs.compareString);
		for (module in usableModules)
			Sys.println('  using $module;');

		Sys.println("");
	}

	/**
		@return The source code file for `module`.
	**/
	static function getSrcFile(module:String, target:Target) {
		final modulePath = module.replace(".", "/");
		var srcFilePath = srcDirectory.makeFilePath('$modulePath$target.hx');
		var srcFile = srcFilePath.tryFind();

		if (srcFile.isSome())
			return srcFile.unwrap();

		srcFilePath = srcDirectory.makeFilePath('$modulePath.hx');
		srcFile = srcFilePath.tryFind();
		if (srcFile.isSome())
			return srcFile.unwrap();

		throw 'File not found for module: $module';
	}

	/**
		Reads The content of the source code file,
		removing comments and package declaration.
	**/
	static function readSrcCode(file:FileRef) {
		var srcCode = file.getContent();
		srcCode = RegExps.lineBreaks.replace(srcCode, "\n");
		srcCode = RegExps.pkg.replace(srcCode, "");
		srcCode = RegExps.comment.replace(srcCode, "");
		return srcCode.trim() + "\n";
	}

	/**
		Prints `message` if `verbose` is `true`.
	**/
	static function log(message:String)
		if (verbose)
			Sys.println(message);
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
	public static final importer = new EReg('import\\s+($rootPackage\\.[^;]+)\\s*;[ \\t]*\n?', "i");

	/**
		Regular expression for matching any using statement.
		After matched, the module can be extracted by `user.matched(1)`.
	**/
	public static final user = new EReg('using\\s+($rootPackage\\.[^;]+)\\s*;[ \\t]*\n?', "i");

	/**
		Regular expression for matching any single-line commented import/using statement.
	**/
	public static final commentedImportUsing = new EReg('//[^\n]*(?:import|using)\\s+$rootPackage\\..+\\s*;[ \\t]*\n?', "ig");

	/**
		Regular expression for matching any line break (CRLF, LF or CR).
	**/
	public static final lineBreaks = ~/\r\n|\n|\r/g;
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
	final ?usable:Bool;
}

/**
	Stores code/modules to be bundled.
**/
typedef CodeBuffer = {
	final codeBlocks:Array<CodeBlock>;
	final modules:Map<String, Bool>;
	final usingModules:Map<String, Bool>;
};

/**
	Source code unit to be bundled.
**/
typedef CodeBlock = {
	final code:String;
	final priority:Int;
};
