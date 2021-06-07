import 'ascii.dart';

/// What character indicates an ansi escape sequence?
// An escape character can also be represented by the following values.
// \e (https://en.wikipedia.org/wiki/Escape_sequences_in_C)
// \033 (https://unix.stackexchange.com/questions/116243/what-does-a-bash-sequence-033999d-mean-and-where-is-it-explained)
const String ansiEscape = '\x1b';

/// What byte indicates an asci escape sequence?
const int ansiEscapeByte = $esc;
