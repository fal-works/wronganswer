package wa;

/**
	Character code.
	Mainly used as output character.
	- On java, based on 16bit integer (or `char`).
	- On eval/js, based on `Int` (same as `Char32`).
**/
abstract Char16(Int) from Int to Int {}
