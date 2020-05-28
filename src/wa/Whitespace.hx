package wa;

import wa.Char;

/**
	Character codes used as whitespace.
**/
enum abstract Whitespace(Char) to Char to Int {
	final LF = "\n".code;
	final SP = " ".code;
	final HT = "\t".code;
	final CR = "\r".code;
}
