package wa;

import wa.Char32;

/**
	Character codes used as whitespace.
**/
enum abstract Whitespace(Char32) to Char32 {
	final LF = "\n".code;
	final SP = " ".code;
	final HT = "\t".code;
	final CR = "\r".code;
}
