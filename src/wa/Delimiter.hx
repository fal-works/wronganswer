package wa;

import wa.Char;

/**
	Character codes used as string delimiters.
**/
enum abstract Delimiter(Char) to Char to Int {
	final LF = "\n".code;
	final SP = " ".code;
}
