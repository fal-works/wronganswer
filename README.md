# wronganswer

Haxe library for competitive programming.

Requires Haxe 4.  
Supports Java, JavaScript and Eval targets with the same API.

## Features

- Standard input
- Standard output
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

- Remove the import statement and append the actual implementation when submitting your answer.
- There are also other additional functions/methods.
