# wronganswer

Haxe library for competitive programming (mainly intended for [AtCoder](https://atcoder.jp/)).

Requires **Haxe 4**.

## Target platforms

Supports the following targets with the same API:

- **Java** (recommended)
- **JavaScript**
- **Eval** (mainly for debug)

## Features

- Standard input (`CharIn`)
- Standard output (`CharOut`)
- Utility functions (`Ut`)
- Debug logger (`Debug`)
- Command for replacing import statements (`replace-imports`)
- (More to be added. Maybe.)

## Caveats

Super unstable!

## Usage

```haxe
import wronganswer.Lib; // Relatively optimized

class Main {
	static function main() {
		final inputBufferCapacity = 32;
		final cin = new CharIn(inputBufferCapacity);

		final strVal = cin.token(); // Reads until next whitespace
		final intVal = cin.int(); // Ditto + casts to Int
		final strVal2 = cin.str(LF); // Reads until next LF

		final outputBufferCapacity = 32;
		final cout = new CharOut(outputBufferCapacity);

		cout.str(strVal); // Appends `String` to the buffer
		cout.space(); // Appends a space
		cout.int(intVal); // Appends `Int`
		cout.lf(); // Appends LF
		cout.print(); // Prints buffered data
		// CharOut methods can also be chained.
	}
}
```

```haxe
import wronganswer.naive.Lib; // Relatively short and simple

class Main {
	static function main() {
		final cin = new CharIn();

		final strVal = cin.str(SP); // Reads until next SP
		final intVal = cin.int(LF); // Reads until next LF and casts to Int

		Sys.println('$strVal $intVal');
	}
}
```

## `replace-imports` command

In order to submit your code to a contest, you have to remove the import statements (e.g. `import wronganswer.Lib;`) and append the actual implementation instead.

This can be automatically done with the command below:

```
haxelib run wronganswer replace-imports [full path of your hx file] [target (java/js/eval)]
```

### Example

```
haxelib run wronganswer replace-imports C:/yourDirectory/Main.hx java
```

In the same directory the above creates a new file `Main.hx.replaced` which includes the code of wronganswer for Java target.

And you might also want to do more automation, such as:

```Batchfile
:: replace-imports.bat (only for Windows!)
haxelib run wronganswer replace-imports %~dp0Main.hx java
clip < %~dp0Main.hx.replaced
```

### Caveats

- This command supports only module-level imports. Avoid importing wildcards or sub-types.
- `using` statements are not supported.
- Make sure that the emitted code is working properly before submitting it.
