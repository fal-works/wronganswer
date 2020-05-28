package wa.naive;

/**
	Character codes used as string delimiters.
**/
enum abstract Delimiter(Int) to Int {
	final LF = "\n".code;
	final SP = " ".code;
}
