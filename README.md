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

		Ut.debug("This is a debug message"); // Prints only #if (eval && debug)

		final outputBufferCapacity = 32;
		final cout = new CharOut(outputBufferCapacity);

		cout.str(strVal); // Appends `String` to buffer
		cout.space(); // Appends a space to buffer
		cout.int(intVal); // Appends `Int` to buffer
		cout.lf(); // Appends LF to buffer
		cout.print(); // Prints buffered data
		// CharOut methods can also be chained
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

		Ut.debug("This is a debug message"); // Prints only #if (eval && debug)
		
		Sys.println('$strVal $intVal');
	}
}
```

## `replace-imports` command

In order to submit your code to the contest,  
you have to remove the import statements (e.g. `import wronganswer.Lib;`) and append the actual implementation instead.

This can be automatically done with the command below:

```
haxelib run wronganswer replace-imports [full path of your hx file] [target (java/js/eval)]
```

This creates a new file `(originalFileName).hx.replaced`.

Note that this supports only module-level imports.  
So avoid importing wildcards or sub-types.
