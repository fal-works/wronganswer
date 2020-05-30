# wronganswer

Haxe library for competitive programming (mainly intended for [AtCoder](https://atcoder.jp/)).

Requires **Haxe 4**.

## Target platforms

Supports following targets with the same API:

- **Java**
- **JavaScript**
- **Eval**

## Features

- Standard input (`wa.CharIn`, `wa.CharIns`, `wa.CharInsInt64`, `wa.CharInsFloat`)
- Standard input - naive (`wa.naive.CharIn`, `wa.naive.CharIns`)
- Standard output (`wa.CharOut`, `wa.CharOuts`)
- Utility static functions (`wa.Ints, wa.Strs, wa.Floats`, `wa.Vecs`)
- Abstracted primitives (`wa.Char16`, `wa.Char32`, `wa.Bits`)
- String buffer (`wa.StrBuf`, `wa.StrBufs`)
- Other (`wa.Printer`, `wa.Whitespace`)
- Debug logger (`wa.Debug`)
- Command for bundling wronganswer modules via import statements (`bundle`)
- (More to be added. Maybe.)

*Note: The package name is `wa`, not the same as the library name `wronganswer`.*

## Caveats

Super unstable!

## Usage > `CharIn`/`CharOut`

These provide optimized standard I/O.

`CharOut` works as a string buffer (on java target, it's based on `PrintWriter`).  
At the end of the program you have to call `print()`/`println()` explicitly.

```haxe
import wa.CharIn;
import wa.CharOut;

class Main {
	static function main() {
		final inputBufferCapacity = 32;
		final cin = new CharIn(inputBufferCapacity);

		final strVal = cin.str(); // Reads until next whitespace
		final intVal = cin.int(); // Ditto + casts to Int
		final strVal2 = cin.until(LF); // Reads until next LF

		final cout = new CharOut();

		cout.str(strVal); // Appends `String` to the buffer
		cout.space(); // Appends a space
		cout.int(intVal); // Appends `Int`
		cout.lf(); // Appends LF
		cout.print(); // Prints buffered data
		// CharOut methods can also be chained.
	}
}
```

### Read all at once

On js target, sequential loading can lead to performance problems.  
So you might also want to read all data at once:

```haxe
import wa.CharIn;
using wa.CharIns; // for all() and other additional methods

class Main {
	static function main() {
		final inputBufferCapacity = 65536;
		final cin = new CharIn(inputBufferCapacity);

		final data:String = cin.all();
		final lines:Array<String> = data.split("\n");

		// ...
	}
}
```

## Usage > naive `CharIn`

You can also use a minimal (but not quite optimized) implementation of `CharIn` to reduce code to be appended when you submit.

```haxe
import wa.naive.CharIn;

class Main {
	static function main() {
		final cin = new CharIn();

		final strVal = cin.str(); // Reads until next whiespace
		final intVal = cin.int(); // Ditto

		Sys.println('$strVal $intVal');
	}
}
```


## Usage > `bundle` command

In order to submit your code to a contest, you might have to bundle it to a single file i.e. remove import statements (e.g. `import wa.CharIn;`) and append the actual implementation instead.

This can be automatically done with the command below:

```
haxelib run wronganswer bundle [full path of your hx file] [target (java/js/eval)]
```

### Example

```
haxelib run wronganswer bundle C:/yourDirectory/Main.hx java
```

In the same directory the above creates a new file `Main.bundle.hx` which includes code of wronganswer for Java target.

And you might also want to do more automation, such as:

```Batchfile
:: bundle.bat (should be placed in the same directory. For Windows only!)
haxelib run wronganswer bundle %~dp0Main.hx java
clip < %~dp0Main.bundle.hx
```

### Help

```
haxelib run wronganswer bundle help
```

The above will display a list of import/using statements that can be resolved.

### Notes

- As you can see by the `help` command, `bundle` works only with module-level imports of wronganswer modules.  
Also avoid using wronganswer features without importing (e.g. `new wa.CharIn(16)`), which cannot be resolved.
- Pay attension to the shadowing of functions (especially if you have `using`) which can lead to inconsistent behavior before/after bundling.
- `bundle` cannot ignore `import`/`using` in multiline comments (`/* ... */`).  
Use singleline comment (`// ...`) for commenting them out.
- Make sure that the emitted code is working properly before submitting it!  
If not, um, good luck.
