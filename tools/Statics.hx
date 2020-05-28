package tools;

/**
	Common fields for `tools` package.
**/
class Statics {
	/**
		The name of this library.
	**/
	public static inline final libName = "wronganswer";

	/**
		The root package name.
	**/
	public static inline final rootPackage = "wa";

	/**
		The version of this library.
	**/
	public static inline final version = haxe.macro.Compiler.getDefine("wronganswer");

	/**
		The URL of the repository.
	**/
	public static inline final repositoryUrl = 'https://github.com/fal-works/$libName';

	/**
		The URL of haxelib page.
	**/
	public static inline final haxelibUrl = 'https://lib.haxe.org/p/${libName}/';
}
