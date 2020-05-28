package tools;

import sys.FileSystem;
import sys.io.File;
import tools.Statics.*;
import wa.Util;

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
				"CharIn", "CharIns", "CharOut", "Delimiter", "Util", "Floats", "StrBuf", "StrBufs", "Vecs", "Bits", "Debug"
			]
		},
		'$rootPackage.naive.*' => {
			priority: 0,
			wildcard: ["CharIn", "Delimiter"]
		},
		'$rootPackage.CharIn' => {priority: 0},
		'$rootPackage.naive.CharIn' => {priority: 0},
		'$rootPackage.CharIns' => {priority: 1},
		'$rootPackage.CharOut' => {priority: 2},
		'$rootPackage.Delimiter' => {priority: 3},
		'$rootPackage.naive.Delimiter' => {priority: 3},
		'$rootPackage.Util' => {priority: 10, usable: true},
		'$rootPackage.Floats' => {priority: 11, usable: true},
		'$rootPackage.StrBuf' => {priority: 20},
		'$rootPackage.StrBufs' => {priority: 21, usable: true},
		'$rootPackage.Vecs' => {priority: 30, usable: true},
		'$rootPackage.Bits' => {priority: 40},
		'$rootPackage.Debug' => {priority: 100}
	];

	/**
		The banner comment to be inserted when replacing.
	**/
	static inline final bannerComment = '/**\n\t$libName v$version / CC0\n\t$repositoryUrl\n**/';

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

		if (1 < args.length && args[1] == "help") {
			showInstruction();
			showResolvableModules();
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

		final buffer:CodeBuffer = {codeBlocks: [], modules: [], usingModules: []};
		final processedMainCode = processCode(mainCode, buffer, target, true);

		final resultCode = buildResultCode(moduleFromPath(mainFilePath), processedMainCode, buffer);
		if (resultCode.length == 0) {
			Sys.println("Found no code to be replaced.");
			return;
		}

		final newFilePath = mainFilePath.replace(".hx", "") + ".bundle.hx";
		createFile(newFilePath, resultCode);
		Sys.println('Create file: $newFilePath');
		Sys.println("Completed.");
	}

	/**
		Extracts the module name from `filePath`.
	**/
	static function moduleFromPath(filePath:String) {
		final lastSlashPosition = Util.imax(filePath.lastIndexOf("/"), filePath.lastIndexOf("\\"));
		final fileName = filePath.substr(lastSlashPosition + 1);
		return fileName.substr(0, fileName.indexOf("."));
	}

	/**
		Calls `processImport()` for each wronganswer-related import statement in `code`.
		@return `code` with the import statements removed.
	**/
	static function processCode(code:String, buffer:CodeBuffer, target:Target, main:Bool) {
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

		final bundlingModules = buffer.modules;
		if (bundlingModules.exists(module)) // already registered
			return code;

		if (main)
			Sys.println('Replacing: import $module;');
		bundlingModules.set(module, true);

		final wildcard = resolvableModules.get(module).wildcard;
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

		final usingModules = buffer.usingModules;
		if (usingModules.exists(module)) // already registered
			return code;

		if (main)
			Sys.println('Replacing: using $module;');
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
		Sys.println("statements that can be resolved:");

		final modules = [for (module in resolvableModules.keys()) module];
		modules.sort(Util.compareString);
		for (module in modules)
			Sys.println('  import $module;');

		final usableModules = [
			for (module => desc in resolvableModules.keyValueIterator()) if (desc.usable) module
		];
		usableModules.sort(Util.compareString);
		for (module in usableModules)
			Sys.println('  using $module;');

		Sys.println("");
	}

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

	/**
		Regular expression for matching any using statement.
		After matched, the module can be extracted by `user.matched(1)`.
	**/
	public static final user = new EReg('using\\s+(.+)\\s*;', "i");
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
