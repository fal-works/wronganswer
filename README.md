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
- Command for bundling wronganswer modules via import statements (`bundle`)
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

## `bundle` command

In order to submit your code to a contest, you might have to bundle it to a single file, i.e. remove import statements (e.g. `import wronganswer.CharIn;`) and append the actual implementation instead.

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
:: bundle.bat (only for Windows!)
haxelib run wronganswer bundle %~dp0Main.hx java
clip < %~dp0Main.bundle.hx
```

### Caveats

- `using` statements are not supported.
- Make sure that the emitted code is working properly before submitting it.
