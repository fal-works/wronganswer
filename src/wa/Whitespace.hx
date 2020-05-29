package wa;

import wa.Char16;
import wa.Char32;

/**
	Character codes used as whitespace.
**/
enum abstract Whitespace(Char32) to Char32 to Char16 {
	final LF = "\n".code;
	final SP = " ".code;
	final HT = "\t".code;
	final CR = "\r".code;
}
