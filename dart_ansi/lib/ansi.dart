// https://notes.burke.libbey.me/ansi-escape-codes/
// https://en.wikipedia.org/wiki/ANSI_escape_code
// http://www.climagic.org/mirrors/VT100_Escape_Codes.html

/// TODO add a second layer to provide a more ordered overview of the spec, move color implementations and commands into that layer.

/// What character, that comes after the escape
/// character indicates an ansi escape sequence?
const String ansiBracket = '[';

/// What byte, that comes after the escape
/// character byte indicates an ansi escape sequence?
const int ansiBracketByte = 0x5B;

/// What character is used to separate arguments in ansi commands?
const commandArgumentSeparator = ";";

/// What byte is used to separate arguments in ansi commands?
const commandArgumentSeparatorByte = 0x3B;

/// What characters represent the control sequence identifier?
const String controlSequenceIdentifier = ansiEscape + ansiBracket;

/// What byte character indicates an ansi escape sequence?
const String ansiEscape = '\x1b';

/// What byte character indicates an ansi escape sequence in C?
/// See: (https://en.wikipedia.org/wiki/Escape_sequences_in_C)
const String ansiEscapeCStyle = '\e';

/// What byte indicates an asci escape sequence?
const int ansiEscapeByte = 0x1B;

/// What integer indicates that the end of a file has been reached?
const int stdinEndOfFileIndicator = -1;

/// What is the size of a byte?
const byteSize = 0xff;

/// What is the size of half of a byte?
const nibbleSize = 0xf;

/// Where does a byte start?
const byteStart = 0;

/// What is the tribit of the black color in the default palette?
const int defaultPaletteBlackTribit = 0;

/// What is the name of the black color?
const String defaultPaletteBlackName = "black";

/// What is the tribit of the red color in the default palette?
const int defaultPaletteRedTribit = 1;

/// What is the name of the red color?
const String defaultPaletteRedName = "red";

/// What is the tribit of the green color in the default palette?
const int defaultPaletteGreenTribit = 2;

/// What is the name of the green color?
const String defaultPaletteGreenName = "green";

/// What is the tribit of the yellow color in the default palette?
const int defaultPaletteYellowTribit = 3;

/// What is the name of the yellow color?
const String defaultPaletteYellowName = "yellow";

/// What is the tribit of the blue color in the default palette?
const int defaultPaletteBlueTribit = 4;

/// What is the name of the blue color?
const String defaultPaletteBlueName = "blue";

/// What is the tribit of the magenta color in the default palette?
const int defaultPaletteMagentaTribit = 5;

/// What is the name of the magenta color?
const String defaultPaletteMagentaName = "magenta";

/// What is the tribit of the cyan color in the default palette?
const int defaultPaletteCyanTribit = 6;

/// What is the name of the cyan color?
const String defaultPaletteCyanName = "cyan";

/// What is the tribit of the white color in the default palette?
const int defaultPaletteWhiteTribit = 7;

/// What is the name of the white color?
const String defaultPaletteWhiteName = "white";

/// What is the smallest number that a color in
/// the extended palette can be (inclusive)?
const int smallestNumberExtendedPalette = 0;

/// What is the biggest number that a color in
/// the extended palette can be (inclusive)?
const int biggestNumberExtendedPalette = 255;

/// TODO be explicit about all extended colors.

const ansiSpace = " ";
const ansiCommandOPrefix = "O";
const ansiCommandOPrefixByte = 0x4F;
const ansiCharEnd = "F";
const ansiCharEndByte = 0x46;
const ansiCharHome = "H";
const ansiCharHomeByte = 0x48;
const ansiCharWordRight = "f";
const ansiCharWordRightByte = 0x66;
const ansiCharWordLeft = "b";
const ansiCharWordLeftByte = 0x62;

const ansiDeviceStatusReportCursorPosition = controlSequenceIdentifier + '6n';
const ansiEraseInDisplayAll = controlSequenceIdentifier + '2J';
const ansiEraseInLineAll = controlSequenceIdentifier + '2K';
const ansiEraseCursorToEnd = controlSequenceIdentifier + 'K';
const ansiHideCursor = controlSequenceIdentifier + ansiHideCursorName;
const ansiShowCursor = controlSequenceIdentifier + ansiShowCursorName;
const ansiCursorLeft = controlSequenceIdentifier + 'D';
const ansiCursorRight = controlSequenceIdentifier + 'C';
const ansiCursorUp = controlSequenceIdentifier + 'A';
const ansiCursorDown = controlSequenceIdentifier + 'B';
const ansiResetCursorPosition = controlSequenceIdentifier + 'H';
const ansiMoveCursorToScreenEdge = controlSequenceIdentifier + '999C' + controlSequenceIdentifier + '999B';
const ansiResetColor = controlSequenceIdentifier + 'm';

const ansiCursorUpName = "A";
const ansiCursorUpNameByte = 0x41;
const ansiCursorDownName = "B";
const ansiCursorDownNameByte = 0x42;
const ansiCursorForwardName = "C";
const ansiCursorForwardNameByte = 0x43;
const ansiCursorBackName = "D";
const ansiCursorBackNameByte = 0x44;
const ansiCursorNextLineName = "E";
const ansiCursorPreviousLineName = "F";
const ansiCursorHorizontalAbsoluteName1 = "G";
const ansiCursorHorizontalAbsoluteName2 = "f";
const ansiCursorPositionName = "H";
const ansiEraseInDisplayName = "J";
const ansiEraseInLineName = "K";
const ansiScrollUpName = "S";
const ansiScrollDownName = "T";
const ansiSaveCursorPosName = "s";
const ansiRestoreCursorPosName = "u";
const ansiSelectGraphicsRenditionName = "m";
const ansiShowCursorName = "?25h";
const ansiHideCursorName = "?25l";

/// TODO rgb colors.
abstract class AnsiBasicPalette {
  /// TODO make this be a string or rather a byte.
  int get paletteNumberTribit;
}

abstract class AnsiBackgroundColor implements AnsiBasicPalette {
  /// An ANSI/VT100 background color code.
  int get backgroundColorCode;
}

abstract class AnsiForegroundColor implements AnsiBasicPalette {
  /// An ANSI/VT100 foreground color code.
  int get foregroundColorCode;
}

abstract class AnsiForegroundBackgroundColor implements AnsiBackgroundColor, AnsiForegroundColor, AnsiBasicPalette {}

/// 0 - 7: standard colors (as in ESC [ 30–37 m).
/// 8 - 15: high intensity colors (as in ESC [ 90–97 m).
/// 16 - 231: 6 × 6 × 6 cube (216 colors): 16 + 36 × r + 6 × g + b (0 ≤ r, g, b ≤ 5).
/// 232 - 255: grayscale from black to white in 24 steps.
///
/// See: https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
/// See: https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
abstract class AnsiExtendedColorPalette {
  int get paletteNumberByte;
}

/// Set graphics rendition mode.
String ansiSelectGraphicsRendition(GraphicsRenditionNode nodes) =>
    controlSequenceIdentifier + nodes.commands.join(commandArgumentSeparator) + ansiSelectGraphicsRenditionName;

/// Move cursor up by n.
String ansiCursorUpBy(int n) => controlSequenceIdentifier + n.toString() + ansiCursorUpName;

/// Move cursor down by n.
String ansiCursorDownBy(int n) => controlSequenceIdentifier + n.toString() + ansiCursorDownName;

/// Move cursor forward by n.
String ansiCursorForwardBy(int n) => controlSequenceIdentifier + n.toString() + ansiCursorForwardName;

/// Move cursor back by n.
String ansiCursorBackBy(int n) => controlSequenceIdentifier + n.toString() + ansiCursorBackName;

/// Move cursor to the beginning of the line n lines down.
String ansiCursorNextLineBy(int n) => controlSequenceIdentifier + n.toString() + ansiCursorNextLineName;

/// Move cursor to the beginning of the line n lines up.
String ansiCursorPreviousLineBy(int n) => controlSequenceIdentifier + n.toString() + ansiCursorPreviousLineName;

/// Move cursor to the column n within the current row.
String ansiCursorHorizontalAbsolute1(int n) => controlSequenceIdentifier + n.toString() + ansiCursorHorizontalAbsoluteName1;

/// Move cursor to the column n within the current row.
String ansiCursorHorizontalAbsolute2(int n) => controlSequenceIdentifier + n.toString() + ansiCursorHorizontalAbsoluteName2;

/// Move cursor to row n, column m, counting from the top left corner.
String ansiCursorPositionTo(int row, int column) =>
    controlSequenceIdentifier + row.toString() + commandArgumentSeparator + column.toString() + ansiCursorPositionName;

/// Clear part of the screen. 0, 1, 2, and 3 have various specific functions.
// TODO Clear Screen: \u001b[{n}J clears the screen
// TODO n=0 clears from cursor until end of screen,
// TODO n=1 clears from cursor to beginning of screen
// TODO n=2 clears entire screen
String ansiEraseInDisplay() => controlSequenceIdentifier + ansiEraseInDisplayName;

/// Clear part of the line. 0, 1, and 2 have various specific functions
// TODO Clear Line: \u001b[{n}K clears the current line
// TODO n=0 clears from cursor to end of line
// TODO n=1 clears from cursor to start of line
// TODO n=2 clears entire line
String ansiEraseInLine() => controlSequenceIdentifier + ansiEraseInLineName;

/// Scroll window up by n lines.
String ansiScrollUpBy(int n) => controlSequenceIdentifier + n.toString() + ansiScrollUpName;

/// Scroll window down by n lines.
String ansiScrollDownBy(int n) => controlSequenceIdentifier + n.toString() + ansiScrollDownName;

/// Save current cursor position for use with u.
String ansiSaveCursorPosition() => controlSequenceIdentifier + ansiSaveCursorPosName;

/// Set cursor back to position last saved by s.
String ansiRestoreCursorPosition() => controlSequenceIdentifier + ansiRestoreCursorPosName;

String ansiSetExtendedForegroundColor(AnsiExtendedColorPalette color) => //
ansiSelectGraphicsRendition(
  GraphicsRenditionNodeExtendedTextColorImpl(color),
);

String ansiSetExtendedBackgroundColor(AnsiExtendedColorPalette color) => //
ansiSelectGraphicsRendition(
  GraphicsRenditionNodeExtendedBackgroundColorImpl(color),
);

String ansiSetTextColor(AnsiForegroundColor color) => //
ansiSelectGraphicsRendition(
  GraphicsRenditionNodeColorImpl(color.foregroundColorCode),
);

String ansiSetBackgroundColor(AnsiBackgroundColor color) => //
ansiSelectGraphicsRendition(
  GraphicsRenditionNodeColorImpl(color.backgroundColorCode),
);

/// Moves the cursor to the start of the line. Same as '\r'.
String ansiCarriageReturn() => //
ansiCursorHorizontalAbsolute1(1);

String ansiSetTextStyles({
  bool bold = false,
  bool underscore = false,
  bool blink = false,
  bool inverted = false,
}) =>
    ansiSelectGraphicsRendition(
      CompositeGraphicsRenditionNode(
        [
          if (bold) const GraphicsRenditionNodeHighlightImpl(),
          if (underscore) const GraphicsRenditionNodeUnderlineImpl(),
          if (blink) const GraphicsRenditionNodeBlinkImpl(),
          if (inverted) const GraphicsRenditionNodeInvertedImpl(),
        ],
      ),
    );

/// TODO find an exhaustive reference.

/// TODO support all these input sequences.
const inputSequences = {
  'A': 'up',
  'B': 'down',
  'C': 'right',
  'D': 'left',
  'E': '5',
  'F': 'end',
  'G': '5',
  'H': 'home',
  '1~': 'home',
  '2~': 'insert',
  '3~': 'delete',
  '4~': 'end',
  '5~': 'page up',
  '6~': 'page down',
  '7~': 'home',
  '8~': 'end',
  '[A': 'f1',
  '[B': 'f2',
  '[C': 'f3',
  '[D': 'f4',
  '[E': 'f5',
  '11~': 'f1',
  '12~': 'f2',
  '13~': 'f3',
  '14~': 'f4',
  '15~': 'f5',
  '17~': 'f6',
  '18~': 'f7',
  '19~': 'f8',
  '20~': 'f9',
  '21~': 'f10',
  '23~': 'f11',
  '24~': 'f12',
  '25~': 'f13',
  '26~': 'f14',
  '28~': 'f15',
  '29~': 'f16',
  '31~': 'f17',
  '32~': 'f18',
  '33~': 'f19',
  '34~': 'f20',
  'OA': 'up',
  'OB': 'down',
  'OC': 'right',
  'OD': 'left',
  'OH': 'home',
  'OF': 'end',
  'OP': 'f1',
  'OQ': 'f2',
  'OR': 'f3',
  'OS': 'f4',
  'Oo': '/',
  'Oj': '*',
  'Om': '-',
  'Ok': '+',
  'Z': 'shift tab',
  'On': '.',
  'Oa': 'meta up',
  'Ob': 'meta down',
  'Oc': 'meta right',
  'Od': 'meta left',
  'a': 'shift up',
  'b': 'shift down',
  'c': 'shift right',
  'd': 'shift left',
  r'2$': 'shift insert',
  r'3$': 'shift delete',
  r'5$': 'shift page up',
  r'6$': 'shift page down',
  r'7$': 'shift home',
  r'8$': 'shift end',
  '2^': 'meta insert',
  '3^': 'meta delete',
  '5^': 'meta page up',
  '6^': 'meta page down',
  '7^': 'meta home',
  '8^': 'meta end',
  'Op': '0',
  'Oq': '1',
  'Or': '2',
  'Os': '3',
  'Ot': '4',
  'Ou': '5',
  'Ov': '6',
  'Ow': '7',
  'Ox': '8',
  'Oy': '9',
  '1A': 'up',
  '1B': 'down',
  '1C': 'right',
  '1D': 'left',
  '1E': '5',
  '1F': 'end',
  '1G': '5',
  '1H': 'home',
  '2A': 'shift up',
  '2B': 'shift down',
  '2C': 'shift right',
  '2D': 'shift left',
  '2E': 'shift 5',
  '2F': 'shift end',
  '2G': 'shift 5',
  '2H': 'shift home',
  '3A': 'meta up',
  '3B': 'meta down',
  '3C': 'meta right',
  '3D': 'meta left',
  '3E': 'meta 5',
  '3F': 'meta end',
  '3G': 'meta 5',
  '3H': 'meta home',
  '4A': 'shift meta up',
  '4B': 'shift meta down',
  '4C': 'shift meta right',
  '4D': 'shift meta left',
  '4E': 'shift meta 5',
  '4F': 'shift meta end',
  '4G': 'shift meta 5',
  '4H': 'shift meta home',
  '5A': 'ctrl up',
  '5B': 'ctrl down',
  '5C': 'ctrl right',
  '5D': 'ctrl left',
  '5E': 'ctrl 5',
  '5F': 'ctrl end',
  '5G': 'ctrl 5',
  '5H': 'ctrl home',
  '6A': 'shift ctrl up',
  '6B': 'shift ctrl down',
  '6C': 'shift ctrl right',
  '6D': 'shift ctrl left',
  '6E': 'shift ctrl 5',
  '6F': 'shift ctrl end',
  '6G': 'shift ctrl 5',
  '6H': 'shift ctrl home',
  '7A': 'meta ctrl up',
  '7B': 'meta ctrl down',
  '7C': 'meta ctrl right',
  '7D': 'meta ctrl left',
  '7E': 'meta ctrl 5',
  '7F': 'meta ctrl end',
  '7G': 'meta ctrl 5',
  '7H': 'meta ctrl home',
  '8A': 'shift meta ctrl up',
  '8B': 'shift meta ctrl down',
  '8C': 'shift meta ctrl right',
  '8D': 'shift meta ctrl left',
  '8E': 'shift meta ctrl 5',
  '8F': 'shift meta ctrl end',
  '8G': 'shift meta ctrl 5',
  '8H': 'shift meta ctrl home',
  '1;1A': 'up',
  '1;1B': 'down',
  '1;1C': 'right',
  '1;1D': 'left',
  '1;1E': '5',
  '1;1F': 'end',
  '1;1G': '5',
  '1;1H': 'home',
  '1;2A': 'shift up',
  '1;2B': 'shift down',
  '1;2C': 'shift right',
  '1;2D': 'shift left',
  '1;2E': 'shift 5',
  '1;2F': 'shift end',
  '1;2G': 'shift 5',
  '1;2H': 'shift home',
  '1;3A': 'meta up',
  '1;3B': 'meta down',
  '1;3C': 'meta right',
  '1;3D': 'meta left',
  '1;3E': 'meta 5',
  '1;3F': 'meta end',
  '1;3G': 'meta 5',
  '1;3H': 'meta home',
  '1;4A': 'shift meta up',
  '1;4B': 'shift meta down',
  '1;4C': 'shift meta right',
  '1;4D': 'shift meta left',
  '1;4E': 'shift meta 5',
  '1;4F': 'shift meta end',
  '1;4G': 'shift meta 5',
  '1;4H': 'shift meta home',
  '1;5A': 'ctrl up',
  '1;5B': 'ctrl down',
  '1;5C': 'ctrl right',
  '1;5D': 'ctrl left',
  '1;5E': 'ctrl 5',
  '1;5F': 'ctrl end',
  '1;5G': 'ctrl 5',
  '1;5H': 'ctrl home',
  '1;6A': 'shift ctrl up',
  '1;6B': 'shift ctrl down',
  '1;6C': 'shift ctrl right',
  '1;6D': 'shift ctrl left',
  '1;6E': 'shift ctrl 5',
  '1;6F': 'shift ctrl end',
  '1;6G': 'shift ctrl 5',
  '1;6H': 'shift ctrl home',
  '1;7A': 'meta ctrl up',
  '1;7B': 'meta ctrl down',
  '1;7C': 'meta ctrl right',
  '1;7D': 'meta ctrl left',
  '1;7E': 'meta ctrl 5',
  '1;7F': 'meta ctrl end',
  '1;7G': 'meta ctrl 5',
  '1;7H': 'meta ctrl home',
  '1;8A': 'shift meta ctrl up',
  '1;8B': 'shift meta ctrl down',
  '1;8C': 'shift meta ctrl right',
  '1;8D': 'shift meta ctrl left',
  '1;8E': 'shift meta ctrl 5',
  '1;8F': 'shift meta ctrl end',
  '1;8G': 'shift meta ctrl 5',
  '1;8H': 'shift meta ctrl home',
  'O1P': 'f1',
  'O1Q': 'f2',
  'O1R': 'f3',
  'O1S': 'f4',
  'O2P': 'shift f1',
  'O2Q': 'shift f2',
  'O2R': 'shift f3',
  'O2S': 'shift f4',
  'O3P': 'meta f1',
  'O3Q': 'meta f2',
  'O3R': 'meta f3',
  'O3S': 'meta f4',
  'O4P': 'shift meta f1',
  'O4Q': 'shift meta f2',
  'O4R': 'shift meta f3',
  'O4S': 'shift meta f4',
  'O5P': 'ctrl f1',
  'O5Q': 'ctrl f2',
  'O5R': 'ctrl f3',
  'O5S': 'ctrl f4',
  'O6P': 'shift ctrl f1',
  'O6Q': 'shift ctrl f2',
  'O6R': 'shift ctrl f3',
  'O6S': 'shift ctrl f4',
  'O7P': 'meta ctrl f1',
  'O7Q': 'meta ctrl f2',
  'O7R': 'meta ctrl f3',
  'O7S': 'meta ctrl f4',
  'O8P': 'shift meta ctrl f1',
  'O8Q': 'shift meta ctrl f2',
  'O8R': 'shift meta ctrl f3',
  'O8S': 'shift meta ctrl f4',
  '3;1~': 'delete',
  '5;1~': 'page up',
  '6;1~': 'page down',
  '11;1~': 'f1',
  '12;1~': 'f2',
  '13;1~': 'f3',
  '14;1~': 'f4',
  '15;1~': 'f5',
  '17;1~': 'f6',
  '18;1~': 'f7',
  '19;1~': 'f8',
  '20;1~': 'f9',
  '21;1~': 'f10',
  '23;1~': 'f11',
  '24;1~': 'f12',
  '25;1~': 'f13',
  '26;1~': 'f14',
  '28;1~': 'f15',
  '29;1~': 'f16',
  '31;1~': 'f17',
  '32;1~': 'f18',
  '33;1~': 'f19',
  '34;1~': 'f20',
  '3;2~': 'shift delete',
  '5;2~': 'shift page up',
  '6;2~': 'shift page down',
  '11;2~': 'shift f1',
  '12;2~': 'shift f2',
  '13;2~': 'shift f3',
  '14;2~': 'shift f4',
  '15;2~': 'shift f5',
  '17;2~': 'shift f6',
  '18;2~': 'shift f7',
  '19;2~': 'shift f8',
  '20;2~': 'shift f9',
  '21;2~': 'shift f10',
  '23;2~': 'shift f11',
  '24;2~': 'shift f12',
  '25;2~': 'shift f13',
  '26;2~': 'shift f14',
  '28;2~': 'shift f15',
  '29;2~': 'shift f16',
  '31;2~': 'shift f17',
  '32;2~': 'shift f18',
  '33;2~': 'shift f19',
  '34;2~': 'shift f20',
  '3;3~': 'meta delete',
  '5;3~': 'meta page up',
  '6;3~': 'meta page down',
  '11;3~': 'meta f1',
  '12;3~': 'meta f2',
  '13;3~': 'meta f3',
  '14;3~': 'meta f4',
  '15;3~': 'meta f5',
  '17;3~': 'meta f6',
  '18;3~': 'meta f7',
  '19;3~': 'meta f8',
  '20;3~': 'meta f9',
  '21;3~': 'meta f10',
  '23;3~': 'meta f11',
  '24;3~': 'meta f12',
  '25;3~': 'meta f13',
  '26;3~': 'meta f14',
  '28;3~': 'meta f15',
  '29;3~': 'meta f16',
  '31;3~': 'meta f17',
  '32;3~': 'meta f18',
  '33;3~': 'meta f19',
  '34;3~': 'meta f20',
  '3;4~': 'shift meta delete',
  '5;4~': 'shift meta page up',
  '6;4~': 'shift meta page down',
  '11;4~': 'shift meta f1',
  '12;4~': 'shift meta f2',
  '13;4~': 'shift meta f3',
  '14;4~': 'shift meta f4',
  '15;4~': 'shift meta f5',
  '17;4~': 'shift meta f6',
  '18;4~': 'shift meta f7',
  '19;4~': 'shift meta f8',
  '20;4~': 'shift meta f9',
  '21;4~': 'shift meta f10',
  '23;4~': 'shift meta f11',
  '24;4~': 'shift meta f12',
  '25;4~': 'shift meta f13',
  '26;4~': 'shift meta f14',
  '28;4~': 'shift meta f15',
  '29;4~': 'shift meta f16',
  '31;4~': 'shift meta f17',
  '32;4~': 'shift meta f18',
  '33;4~': 'shift meta f19',
  '34;4~': 'shift meta f20',
  '3;5~': 'ctrl delete',
  '5;5~': 'ctrl page up',
  '6;5~': 'ctrl page down',
  '11;5~': 'ctrl f1',
  '12;5~': 'ctrl f2',
  '13;5~': 'ctrl f3',
  '14;5~': 'ctrl f4',
  '15;5~': 'ctrl f5',
  '17;5~': 'ctrl f6',
  '18;5~': 'ctrl f7',
  '19;5~': 'ctrl f8',
  '20;5~': 'ctrl f9',
  '21;5~': 'ctrl f10',
  '23;5~': 'ctrl f11',
  '24;5~': 'ctrl f12',
  '25;5~': 'ctrl f13',
  '26;5~': 'ctrl f14',
  '28;5~': 'ctrl f15',
  '29;5~': 'ctrl f16',
  '31;5~': 'ctrl f17',
  '32;5~': 'ctrl f18',
  '33;5~': 'ctrl f19',
  '34;5~': 'ctrl f20',
  '3;6~': 'shift ctrl delete',
  '5;6~': 'shift ctrl page up',
  '6;6~': 'shift ctrl page down',
  '11;6~': 'shift ctrl f1',
  '12;6~': 'shift ctrl f2',
  '13;6~': 'shift ctrl f3',
  '14;6~': 'shift ctrl f4',
  '15;6~': 'shift ctrl f5',
  '17;6~': 'shift ctrl f6',
  '18;6~': 'shift ctrl f7',
  '19;6~': 'shift ctrl f8',
  '20;6~': 'shift ctrl f9',
  '21;6~': 'shift ctrl f10',
  '23;6~': 'shift ctrl f11',
  '24;6~': 'shift ctrl f12',
  '25;6~': 'shift ctrl f13',
  '26;6~': 'shift ctrl f14',
  '28;6~': 'shift ctrl f15',
  '29;6~': 'shift ctrl f16',
  '31;6~': 'shift ctrl f17',
  '32;6~': 'shift ctrl f18',
  '33;6~': 'shift ctrl f19',
  '34;6~': 'shift ctrl f20',
  '3;7~': 'meta ctrl delete',
  '5;7~': 'meta ctrl page up',
  '6;7~': 'meta ctrl page down',
  '11;7~': 'meta ctrl f1',
  '12;7~': 'meta ctrl f2',
  '13;7~': 'meta ctrl f3',
  '14;7~': 'meta ctrl f4',
  '15;7~': 'meta ctrl f5',
  '17;7~': 'meta ctrl f6',
  '18;7~': 'meta ctrl f7',
  '19;7~': 'meta ctrl f8',
  '20;7~': 'meta ctrl f9',
  '21;7~': 'meta ctrl f10',
  '23;7~': 'meta ctrl f11',
  '24;7~': 'meta ctrl f12',
  '25;7~': 'meta ctrl f13',
  '26;7~': 'meta ctrl f14',
  '28;7~': 'meta ctrl f15',
  '29;7~': 'meta ctrl f16',
  '31;7~': 'meta ctrl f17',
  '32;7~': 'meta ctrl f18',
  '33;7~': 'meta ctrl f19',
  '34;7~': 'meta ctrl f20',
  '3;8~': 'shift meta ctrl delete',
  '5;8~': 'shift meta ctrl page up',
  '6;8~': 'shift meta ctrl page down',
  '11;8~': 'shift meta ctrl f1',
  '12;8~': 'shift meta ctrl f2',
  '13;8~': 'shift meta ctrl f3',
  '14;8~': 'shift meta ctrl f4',
  '15;8~': 'shift meta ctrl f5',
  '17;8~': 'shift meta ctrl f6',
  '18;8~': 'shift meta ctrl f7',
  '19;8~': 'shift meta ctrl f8',
  '20;8~': 'shift meta ctrl f9',
  '21;8~': 'shift meta ctrl f10',
  '23;8~': 'shift meta ctrl f11',
  '24;8~': 'shift meta ctrl f12',
  '25;8~': 'shift meta ctrl f13',
  '26;8~': 'shift meta ctrl f14',
  '28;8~': 'shift meta ctrl f15',
  '29;8~': 'shift meta ctrl f16',
  '31;8~': 'shift meta ctrl f17',
  '32;8~': 'shift meta ctrl f18',
  '33;8~': 'shift meta ctrl f19',
  '34;8~': 'shift meta ctrl f20',
  'M': 'mouse',
  '0n': 'status ok'
};

/// Base node for graphics rendition command nodes.
/// TODO crossed out 9 enable 29 disable.
/// TODO frame 51 enable 54 disable.
/// TODO encircled 52 enable 54 disable.
/// TODO overlined 53 enable 55 disable.
/// TODO what is conceal at 8 and reveal at 28.
abstract class GraphicsRenditionNode {
  Iterable<String> get commands;
}

/// Reset: turn off all attributes.
class GraphicsRenditionNodeResetImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeResetImpl();

  @override
  Iterable<String> get commands => const ["0"];
}

/// Bold (or bright, it’s up to the terminal and the user config to some extent).
/// TODO disable bold is 22?
class GraphicsRenditionNodeHighlightImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeHighlightImpl();

  @override
  Iterable<String> get commands => const ["1"];
}

/// Italic.
/// TODO disable italic is 23?
class GraphicsRenditionNodeItalicImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeItalicImpl();

  @override
  Iterable<String> get commands => const ["3"];
}

/// Underline.
/// TODO disable underline is 24?
class GraphicsRenditionNodeUnderlineImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeUnderlineImpl();

  @override
  Iterable<String> get commands => const ["4"];
}

/// Blink.
/// TODO disable blink is 25?
class GraphicsRenditionNodeBlinkImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeBlinkImpl();

  @override
  Iterable<String> get commands => const ["5"];
}

/// Inverted also known as reversed.
///
/// Inverts colors.
/// TODO disable inverted is 27?
class GraphicsRenditionNodeInvertedImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeInvertedImpl();

  @override
  Iterable<String> get commands => const ["7"];
}

/// Set text colour from the basic colour palette of 0–7.
/// TODO reset text color is 39?
class GraphicsRenditionNodeTextColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeTextColorImpl(this.color);

  @override
  Iterable<String> get commands sync* {
    yield "3" + color.paletteNumberTribit.toString();
  }
}

/// Set text colour from the bright colour palette of 0–7.
class GraphicsRenditionNodeBrightTextColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeBrightTextColorImpl(this.color);

  @override
  Iterable<String> get commands sync* {
    yield "9" + color.paletteNumberTribit.toString();
  }
}

/// Set background colour.
/// TODO reset BG color is 49?
class GraphicsRenditionNodeBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeBackgroundColorImpl(this.color);

  @override
  Iterable<String> get commands sync* {
    yield "4" + color.paletteNumberTribit.toString();
  }
}

/// Set background colour from the bright colour palette of 0–7.
class GraphicsRenditionNodeBrightBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeBrightBackgroundColorImpl(this.color);

  @override
  Iterable<String> get commands sync* {
    yield "10" + color.paletteNumberTribit.toString();
  }
}

/// Sets text or background color. Bright or normal color.
/// What will be set depends on the value given.
///
/// This is an unsafe operation and should be avoided.
class GraphicsRenditionNodeColorImpl implements GraphicsRenditionNode {
  final int raw;

  const GraphicsRenditionNodeColorImpl(this.raw);

  @override
  Iterable<String> get commands sync* {
    yield raw.toString();
  }
}

/// Set text colour to index n in a 256-colour palette
/// See https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
class GraphicsRenditionNodeExtendedTextColorImpl implements GraphicsRenditionNode {
  final AnsiExtendedColorPalette color;

  const GraphicsRenditionNodeExtendedTextColorImpl(this.color);

  @override
  Iterable<String> get commands sync* {
    yield "38";
    yield "5";
    yield color.paletteNumberByte.toString();
  }
}

/// Set background colour to index n in a 256-colour palette.
/// See https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
class GraphicsRenditionNodeExtendedBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiExtendedColorPalette color;

  const GraphicsRenditionNodeExtendedBackgroundColorImpl(this.color);

  @override
  Iterable<String> get commands sync* {
    yield "48";
    yield "5";
    yield color.paletteNumberByte.toString();
  }
}

/// Set text colour to an RGB value.
class GraphicsRenditionNodeRGBTextColorImpl implements GraphicsRenditionNode {
  final int r;
  final int g;
  final int b;

  const GraphicsRenditionNodeRGBTextColorImpl(this.r, this.g, this.b);

  @override
  Iterable<String> get commands sync* {
    yield "38";
    yield "2";
    yield r.toString();
    yield g.toString();
    yield b.toString();
  }
}

/// Set background colour to an RGB value.
class GraphicsRenditionNodeRGBBackgroundColorImpl implements GraphicsRenditionNode {
  final int r;
  final int g;
  final int b;

  const GraphicsRenditionNodeRGBBackgroundColorImpl(this.r, this.g, this.b);

  @override
  Iterable<String> get commands sync* {
    yield "48";
    yield "2";
    yield r.toString();
    yield g.toString();
    yield b.toString();
  }
}

/// Allows you to treat multiple [GraphicsRenditionNode] instances as one.
class CompositeGraphicsRenditionNode implements GraphicsRenditionNode {
  final Iterable<GraphicsRenditionNode> nodes;

  const CompositeGraphicsRenditionNode(this.nodes);

  @override
  Iterable<String> get commands sync* {
    for (final node in nodes) {
      yield* node.commands;
    }
  }
}

/// See https://jonasjacek.github.io/colors/
abstract class AnsiExtendedColors implements AnsiExtendedColorPalette {
  static const Black = AnsiExtendedColorPaletteRawImpl(smallestNumberExtendedPalette, "Black");
  static const Maroon = AnsiExtendedColorPaletteRawImpl(1, "Maroon");
  static const Green = AnsiExtendedColorPaletteRawImpl(2, "Green");
  static const Olive = AnsiExtendedColorPaletteRawImpl(3, "Olive");
  static const Navy = AnsiExtendedColorPaletteRawImpl(4, "Navy");
  static const Purple = AnsiExtendedColorPaletteRawImpl(5, "Purple");
  static const Teal = AnsiExtendedColorPaletteRawImpl(6, "Teal");
  static const Silver = AnsiExtendedColorPaletteRawImpl(7, "Silver");
  static const Grey = AnsiExtendedColorPaletteRawImpl(8, "Grey");
  static const Red = AnsiExtendedColorPaletteRawImpl(9, "Red");
  static const Lime = AnsiExtendedColorPaletteRawImpl(10, "Lime");
  static const Yellow = AnsiExtendedColorPaletteRawImpl(11, "Yellow");
  static const Blue = AnsiExtendedColorPaletteRawImpl(12, "Blue");
  static const Fuchsia = AnsiExtendedColorPaletteRawImpl(13, "Fuchsia");
  static const Aqua = AnsiExtendedColorPaletteRawImpl(14, "Aqua");
  static const White = AnsiExtendedColorPaletteRawImpl(15, "White");
  static const Grey0 = AnsiExtendedColorPaletteRawImpl(16, "Grey0");
  static const NavyBlue = AnsiExtendedColorPaletteRawImpl(17, "NavyBlue");
  static const DarkBlue = AnsiExtendedColorPaletteRawImpl(18, "DarkBlue");
  static const Blue3 = AnsiExtendedColorPaletteRawImpl(19, "Blue3");
  static const Blue3_2 = AnsiExtendedColorPaletteRawImpl(20, "Blue3_2");
  static const Blue1 = AnsiExtendedColorPaletteRawImpl(21, "Blue1");
  static const DarkGreen = AnsiExtendedColorPaletteRawImpl(22, "DarkGreen");
  static const DeepSkyBlue4 = AnsiExtendedColorPaletteRawImpl(23, "DeepSkyBlue4");
  static const DeepSkyBlue4_2 = AnsiExtendedColorPaletteRawImpl(24, "DeepSkyBlue4_2");
  static const DeepSkyBlue4_3 = AnsiExtendedColorPaletteRawImpl(25, "DeepSkyBlue4_3");
  static const DodgerBlue3 = AnsiExtendedColorPaletteRawImpl(26, "DodgerBlue3");
  static const DodgerBlue2 = AnsiExtendedColorPaletteRawImpl(27, "DodgerBlue2");
  static const Green4 = AnsiExtendedColorPaletteRawImpl(28, "Green4");
  static const SpringGreen4 = AnsiExtendedColorPaletteRawImpl(29, "SpringGreen4");
  static const Turquoise4 = AnsiExtendedColorPaletteRawImpl(30, "Turquoise4");
  static const DeepSkyBlue3 = AnsiExtendedColorPaletteRawImpl(31, "DeepSkyBlue3");
  static const DeepSkyBlue3_2 = AnsiExtendedColorPaletteRawImpl(32, "DeepSkyBlue3_2");
  static const DodgerBlue1 = AnsiExtendedColorPaletteRawImpl(33, "DodgerBlue1");
  static const Green3 = AnsiExtendedColorPaletteRawImpl(34, "Green3");
  static const SpringGreen3 = AnsiExtendedColorPaletteRawImpl(35, "SpringGreen3");
  static const DarkCyan = AnsiExtendedColorPaletteRawImpl(36, "DarkCyan");
  static const LightSeaGreen = AnsiExtendedColorPaletteRawImpl(37, "LightSeaGreen");
  static const DeepSkyBlue2 = AnsiExtendedColorPaletteRawImpl(38, "DeepSkyBlue2");
  static const DeepSkyBlue1 = AnsiExtendedColorPaletteRawImpl(39, "DeepSkyBlue1");
  static const Green3_2 = AnsiExtendedColorPaletteRawImpl(40, "Green3_2");
  static const SpringGreen3_2 = AnsiExtendedColorPaletteRawImpl(41, "SpringGreen3_2");
  static const SpringGreen2 = AnsiExtendedColorPaletteRawImpl(42, "SpringGreen2");
  static const Cyan3 = AnsiExtendedColorPaletteRawImpl(43, "Cyan3");
  static const DarkTurquoise = AnsiExtendedColorPaletteRawImpl(44, "DarkTurquoise");
  static const Turquoise2 = AnsiExtendedColorPaletteRawImpl(45, "Turquoise2");
  static const Green1 = AnsiExtendedColorPaletteRawImpl(46, "Green1");
  static const SpringGreen2_2 = AnsiExtendedColorPaletteRawImpl(47, "SpringGreen2_2");
  static const SpringGreen1 = AnsiExtendedColorPaletteRawImpl(48, "SpringGreen1");
  static const MediumSpringGreen = AnsiExtendedColorPaletteRawImpl(49, "MediumSpringGreen");
  static const Cyan2 = AnsiExtendedColorPaletteRawImpl(50, "Cyan2");
  static const Cyan1 = AnsiExtendedColorPaletteRawImpl(51, "Cyan1");
  static const DarkRed = AnsiExtendedColorPaletteRawImpl(52, "DarkRed");
  static const DeepPink4 = AnsiExtendedColorPaletteRawImpl(53, "DeepPink4");
  static const Purple4 = AnsiExtendedColorPaletteRawImpl(54, "Purple4");
  static const Purple4_2 = AnsiExtendedColorPaletteRawImpl(55, "Purple4_2");
  static const Purple3 = AnsiExtendedColorPaletteRawImpl(56, "Purple3");
  static const BlueViolet = AnsiExtendedColorPaletteRawImpl(57, "BlueViolet");
  static const Orange4 = AnsiExtendedColorPaletteRawImpl(58, "Orange4");
  static const Grey37 = AnsiExtendedColorPaletteRawImpl(59, "Grey37");
  static const MediumPurple4 = AnsiExtendedColorPaletteRawImpl(60, "MediumPurple4");
  static const SlateBlue3 = AnsiExtendedColorPaletteRawImpl(61, "SlateBlue3");
  static const SlateBlue3_2 = AnsiExtendedColorPaletteRawImpl(62, "SlateBlue3_2");
  static const RoyalBlue1 = AnsiExtendedColorPaletteRawImpl(63, "RoyalBlue1");
  static const Chartreuse4 = AnsiExtendedColorPaletteRawImpl(64, "Chartreuse4");
  static const DarkSeaGreen4 = AnsiExtendedColorPaletteRawImpl(65, "DarkSeaGreen4");
  static const PaleTurquoise4 = AnsiExtendedColorPaletteRawImpl(66, "PaleTurquoise4");
  static const SteelBlue = AnsiExtendedColorPaletteRawImpl(67, "SteelBlue");
  static const SteelBlue3 = AnsiExtendedColorPaletteRawImpl(68, "SteelBlue3");
  static const CornflowerBlue = AnsiExtendedColorPaletteRawImpl(69, "CornflowerBlue");
  static const Chartreuse3 = AnsiExtendedColorPaletteRawImpl(70, "Chartreuse3");
  static const DarkSeaGreen4_2 = AnsiExtendedColorPaletteRawImpl(71, "DarkSeaGreen4_2");
  static const CadetBlue = AnsiExtendedColorPaletteRawImpl(72, "CadetBlue");
  static const CadetBlue_2 = AnsiExtendedColorPaletteRawImpl(73, "CadetBlue_2");
  static const SkyBlue3 = AnsiExtendedColorPaletteRawImpl(74, "SkyBlue3");
  static const SteelBlue1 = AnsiExtendedColorPaletteRawImpl(75, "SteelBlue1");
  static const Chartreuse3_2 = AnsiExtendedColorPaletteRawImpl(76, "Chartreuse3_2");
  static const PaleGreen3 = AnsiExtendedColorPaletteRawImpl(77, "PaleGreen3");
  static const SeaGreen3 = AnsiExtendedColorPaletteRawImpl(78, "SeaGreen3");
  static const Aquamarine3 = AnsiExtendedColorPaletteRawImpl(79, "Aquamarine3");
  static const MediumTurquoise = AnsiExtendedColorPaletteRawImpl(80, "MediumTurquoise");
  static const SteelBlue1_2 = AnsiExtendedColorPaletteRawImpl(81, "SteelBlue1_2");
  static const Chartreuse2 = AnsiExtendedColorPaletteRawImpl(82, "Chartreuse2");
  static const SeaGreen2 = AnsiExtendedColorPaletteRawImpl(83, "SeaGreen2");
  static const SeaGreen1 = AnsiExtendedColorPaletteRawImpl(84, "SeaGreen1");
  static const SeaGreen1_2 = AnsiExtendedColorPaletteRawImpl(85, "SeaGreen1_2");
  static const Aquamarine1 = AnsiExtendedColorPaletteRawImpl(86, "Aquamarine1");
  static const DarkSlateGray2 = AnsiExtendedColorPaletteRawImpl(87, "DarkSlateGray2");
  static const DarkRed_2 = AnsiExtendedColorPaletteRawImpl(88, "DarkRed_2");
  static const DeepPink4_2 = AnsiExtendedColorPaletteRawImpl(89, "DeepPink4_2");
  static const DarkMagenta = AnsiExtendedColorPaletteRawImpl(90, "DarkMagenta");
  static const DarkMagenta_2 = AnsiExtendedColorPaletteRawImpl(91, "DarkMagenta_2");
  static const DarkViolet = AnsiExtendedColorPaletteRawImpl(92, "DarkViolet");
  static const Purple_2 = AnsiExtendedColorPaletteRawImpl(93, "Purple_2");
  static const Orange4_2 = AnsiExtendedColorPaletteRawImpl(94, "Orange4_2");
  static const LightPink4 = AnsiExtendedColorPaletteRawImpl(95, "LightPink4");
  static const Plum4 = AnsiExtendedColorPaletteRawImpl(96, "Plum4");
  static const MediumPurple3 = AnsiExtendedColorPaletteRawImpl(97, "MediumPurple3");
  static const MediumPurple3_2 = AnsiExtendedColorPaletteRawImpl(98, "MediumPurple3_2");
  static const SlateBlue1 = AnsiExtendedColorPaletteRawImpl(99, "SlateBlue1");
  static const Yellow4 = AnsiExtendedColorPaletteRawImpl(100, "Yellow4");
  static const Wheat4 = AnsiExtendedColorPaletteRawImpl(101, "Wheat4");
  static const Grey53 = AnsiExtendedColorPaletteRawImpl(102, "Grey53");
  static const LightSlateGrey = AnsiExtendedColorPaletteRawImpl(103, "LightSlateGrey");
  static const MediumPurple = AnsiExtendedColorPaletteRawImpl(104, "MediumPurple");
  static const LightSlateBlue = AnsiExtendedColorPaletteRawImpl(105, "LightSlateBlue");
  static const Yellow4_2 = AnsiExtendedColorPaletteRawImpl(106, "Yellow4_2");
  static const DarkOliveGreen3 = AnsiExtendedColorPaletteRawImpl(107, "DarkOliveGreen3");
  static const DarkSeaGreen = AnsiExtendedColorPaletteRawImpl(108, "DarkSeaGreen");
  static const LightSkyBlue3 = AnsiExtendedColorPaletteRawImpl(109, "LightSkyBlue3");
  static const LightSkyBlue3_2 = AnsiExtendedColorPaletteRawImpl(110, "LightSkyBlue3_2");
  static const SkyBlue2 = AnsiExtendedColorPaletteRawImpl(111, "SkyBlue2");
  static const Chartreuse2_2 = AnsiExtendedColorPaletteRawImpl(112, "Chartreuse2_2");
  static const DarkOliveGreen3_2 = AnsiExtendedColorPaletteRawImpl(113, "DarkOliveGreen3_2");
  static const PaleGreen3_2 = AnsiExtendedColorPaletteRawImpl(114, "PaleGreen3_2");
  static const DarkSeaGreen3 = AnsiExtendedColorPaletteRawImpl(115, "DarkSeaGreen3");
  static const DarkSlateGray3 = AnsiExtendedColorPaletteRawImpl(116, "DarkSlateGray3");
  static const SkyBlue1 = AnsiExtendedColorPaletteRawImpl(117, "SkyBlue1");
  static const Chartreuse1 = AnsiExtendedColorPaletteRawImpl(118, "Chartreuse1");
  static const LightGreen = AnsiExtendedColorPaletteRawImpl(119, "LightGreen");
  static const LightGreen_2 = AnsiExtendedColorPaletteRawImpl(120, "LightGreen_2");
  static const PaleGreen1 = AnsiExtendedColorPaletteRawImpl(121, "PaleGreen1");
  static const Aquamarine1_2 = AnsiExtendedColorPaletteRawImpl(122, "Aquamarine1_2");
  static const DarkSlateGray1 = AnsiExtendedColorPaletteRawImpl(123, "DarkSlateGray1");
  static const Red3 = AnsiExtendedColorPaletteRawImpl(124, "Red3");
  static const DeepPink4_3 = AnsiExtendedColorPaletteRawImpl(125, "DeepPink4_3");
  static const MediumVioletRed = AnsiExtendedColorPaletteRawImpl(126, "MediumVioletRed");
  static const Magenta3 = AnsiExtendedColorPaletteRawImpl(127, "Magenta3");
  static const DarkViolet_2 = AnsiExtendedColorPaletteRawImpl(128, "DarkViolet_2");
  static const Purple_3 = AnsiExtendedColorPaletteRawImpl(129, "Purple_3");
  static const DarkOrange3 = AnsiExtendedColorPaletteRawImpl(130, "DarkOrange3");
  static const IndianRed = AnsiExtendedColorPaletteRawImpl(131, "IndianRed");
  static const HotPink3 = AnsiExtendedColorPaletteRawImpl(132, "HotPink3");
  static const MediumOrchid3 = AnsiExtendedColorPaletteRawImpl(133, "MediumOrchid3");
  static const MediumOrchid = AnsiExtendedColorPaletteRawImpl(134, "MediumOrchid");
  static const MediumPurple2 = AnsiExtendedColorPaletteRawImpl(135, "MediumPurple2");
  static const DarkGoldenrod = AnsiExtendedColorPaletteRawImpl(136, "DarkGoldenrod");
  static const LightSalmon3 = AnsiExtendedColorPaletteRawImpl(137, "LightSalmon3");
  static const RosyBrown = AnsiExtendedColorPaletteRawImpl(138, "RosyBrown");
  static const Grey63 = AnsiExtendedColorPaletteRawImpl(139, "Grey63");
  static const MediumPurple2_2 = AnsiExtendedColorPaletteRawImpl(140, "MediumPurple2_2");
  static const MediumPurple1 = AnsiExtendedColorPaletteRawImpl(141, "MediumPurple1");
  static const Gold3 = AnsiExtendedColorPaletteRawImpl(142, "Gold3");
  static const DarkKhaki = AnsiExtendedColorPaletteRawImpl(143, "DarkKhaki");
  static const NavajoWhite3 = AnsiExtendedColorPaletteRawImpl(144, "NavajoWhite3");
  static const Grey69 = AnsiExtendedColorPaletteRawImpl(145, "Grey69");
  static const LightSteelBlue3 = AnsiExtendedColorPaletteRawImpl(146, "LightSteelBlue3");
  static const LightSteelBlue = AnsiExtendedColorPaletteRawImpl(147, "LightSteelBlue");
  static const Yellow3 = AnsiExtendedColorPaletteRawImpl(148, "Yellow3");
  static const DarkOliveGreen3_3 = AnsiExtendedColorPaletteRawImpl(149, "DarkOliveGreen3_3");
  static const DarkSeaGreen3_2 = AnsiExtendedColorPaletteRawImpl(150, "DarkSeaGreen3_2");
  static const DarkSeaGreen2 = AnsiExtendedColorPaletteRawImpl(151, "DarkSeaGreen2");
  static const LightCyan3 = AnsiExtendedColorPaletteRawImpl(152, "LightCyan3");
  static const LightSkyBlue1 = AnsiExtendedColorPaletteRawImpl(153, "LightSkyBlue1");
  static const GreenYellow = AnsiExtendedColorPaletteRawImpl(154, "GreenYellow");
  static const DarkOliveGreen2 = AnsiExtendedColorPaletteRawImpl(155, "DarkOliveGreen2");
  static const PaleGreen1_2 = AnsiExtendedColorPaletteRawImpl(156, "PaleGreen1_2");
  static const DarkSeaGreen2_2 = AnsiExtendedColorPaletteRawImpl(157, "DarkSeaGreen2_2");
  static const DarkSeaGreen1 = AnsiExtendedColorPaletteRawImpl(158, "DarkSeaGreen1");
  static const PaleTurquoise1 = AnsiExtendedColorPaletteRawImpl(159, "PaleTurquoise1");
  static const Red3_2 = AnsiExtendedColorPaletteRawImpl(160, "Red3_2");
  static const DeepPink3 = AnsiExtendedColorPaletteRawImpl(161, "DeepPink3");
  static const DeepPink3_2 = AnsiExtendedColorPaletteRawImpl(162, "DeepPink3_2");
  static const Magenta3_2 = AnsiExtendedColorPaletteRawImpl(163, "Magenta3_2");
  static const Magenta3_3 = AnsiExtendedColorPaletteRawImpl(164, "Magenta3_3");
  static const Magenta2 = AnsiExtendedColorPaletteRawImpl(165, "Magenta2");
  static const DarkOrange3_2 = AnsiExtendedColorPaletteRawImpl(166, "DarkOrange3_2");
  static const IndianRed_2 = AnsiExtendedColorPaletteRawImpl(167, "IndianRed_2");
  static const HotPink3_2 = AnsiExtendedColorPaletteRawImpl(168, "HotPink3_2");
  static const HotPink2 = AnsiExtendedColorPaletteRawImpl(169, "HotPink2");
  static const Orchid = AnsiExtendedColorPaletteRawImpl(170, "Orchid");
  static const MediumOrchid1 = AnsiExtendedColorPaletteRawImpl(171, "MediumOrchid1");
  static const Orange3 = AnsiExtendedColorPaletteRawImpl(172, "Orange3");
  static const LightSalmon3_2 = AnsiExtendedColorPaletteRawImpl(173, "LightSalmon3_2");
  static const LightPink3 = AnsiExtendedColorPaletteRawImpl(174, "LightPink3");
  static const Pink3 = AnsiExtendedColorPaletteRawImpl(175, "Pink3");
  static const Plum3 = AnsiExtendedColorPaletteRawImpl(176, "Plum3");
  static const Violet = AnsiExtendedColorPaletteRawImpl(177, "Violet");
  static const Gold3_2 = AnsiExtendedColorPaletteRawImpl(178, "Gold3_2");
  static const LightGoldenrod3 = AnsiExtendedColorPaletteRawImpl(179, "LightGoldenrod3");
  static const Tan = AnsiExtendedColorPaletteRawImpl(180, "Tan");
  static const MistyRose3 = AnsiExtendedColorPaletteRawImpl(181, "MistyRose3");
  static const Thistle3 = AnsiExtendedColorPaletteRawImpl(182, "Thistle3");
  static const Plum2 = AnsiExtendedColorPaletteRawImpl(183, "Plum2");
  static const Yellow3_2 = AnsiExtendedColorPaletteRawImpl(184, "Yellow3_2");
  static const Khaki3 = AnsiExtendedColorPaletteRawImpl(185, "Khaki3");
  static const LightGoldenrod2 = AnsiExtendedColorPaletteRawImpl(186, "LightGoldenrod2");
  static const LightYellow3 = AnsiExtendedColorPaletteRawImpl(187, "LightYellow3");
  static const Grey84 = AnsiExtendedColorPaletteRawImpl(188, "Grey84");
  static const LightSteelBlue1 = AnsiExtendedColorPaletteRawImpl(189, "LightSteelBlue1");
  static const Yellow2 = AnsiExtendedColorPaletteRawImpl(190, "Yellow2");
  static const DarkOliveGreen1 = AnsiExtendedColorPaletteRawImpl(191, "DarkOliveGreen1");
  static const DarkOliveGreen1_2 = AnsiExtendedColorPaletteRawImpl(192, "DarkOliveGreen1_2");
  static const DarkSeaGreen1_2 = AnsiExtendedColorPaletteRawImpl(193, "DarkSeaGreen1_2");
  static const Honeydew2 = AnsiExtendedColorPaletteRawImpl(194, "Honeydew2");
  static const LightCyan1 = AnsiExtendedColorPaletteRawImpl(195, "LightCyan1");
  static const Red1 = AnsiExtendedColorPaletteRawImpl(196, "Red1");
  static const DeepPink2 = AnsiExtendedColorPaletteRawImpl(197, "DeepPink2");
  static const DeepPink1 = AnsiExtendedColorPaletteRawImpl(198, "DeepPink1");
  static const DeepPink1_2 = AnsiExtendedColorPaletteRawImpl(199, "DeepPink1_2");
  static const Magenta2_2 = AnsiExtendedColorPaletteRawImpl(200, "Magenta2_2");
  static const Magenta1 = AnsiExtendedColorPaletteRawImpl(201, "Magenta1");
  static const OrangeRed1 = AnsiExtendedColorPaletteRawImpl(202, "OrangeRed1");
  static const IndianRed1 = AnsiExtendedColorPaletteRawImpl(203, "IndianRed1");
  static const IndianRed1_2 = AnsiExtendedColorPaletteRawImpl(204, "IndianRed1_2");
  static const HotPink = AnsiExtendedColorPaletteRawImpl(205, "HotPink");
  static const HotPink_2 = AnsiExtendedColorPaletteRawImpl(206, "HotPink_2");
  static const MediumOrchid1_2 = AnsiExtendedColorPaletteRawImpl(207, "MediumOrchid1_2");
  static const DarkOrange = AnsiExtendedColorPaletteRawImpl(208, "DarkOrange");
  static const Salmon1 = AnsiExtendedColorPaletteRawImpl(209, "Salmon1");
  static const LightCoral = AnsiExtendedColorPaletteRawImpl(210, "LightCoral");
  static const PaleVioletRed1 = AnsiExtendedColorPaletteRawImpl(211, "PaleVioletRed1");
  static const Orchid2 = AnsiExtendedColorPaletteRawImpl(212, "Orchid2");
  static const Orchid1 = AnsiExtendedColorPaletteRawImpl(213, "Orchid1");
  static const Orange1 = AnsiExtendedColorPaletteRawImpl(214, "Orange1");
  static const SandyBrown = AnsiExtendedColorPaletteRawImpl(215, "SandyBrown");
  static const LightSalmon1 = AnsiExtendedColorPaletteRawImpl(216, "LightSalmon1");
  static const LightPink1 = AnsiExtendedColorPaletteRawImpl(217, "LightPink1");
  static const Pink1 = AnsiExtendedColorPaletteRawImpl(218, "Pink1");
  static const Plum1 = AnsiExtendedColorPaletteRawImpl(219, "Plum1");
  static const Gold1 = AnsiExtendedColorPaletteRawImpl(220, "Gold1");
  static const LightGoldenrod2_2 = AnsiExtendedColorPaletteRawImpl(221, "LightGoldenrod2_2");
  static const LightGoldenrod2_3 = AnsiExtendedColorPaletteRawImpl(222, "LightGoldenrod2_3");
  static const NavajoWhite1 = AnsiExtendedColorPaletteRawImpl(223, "NavajoWhite1");
  static const MistyRose1 = AnsiExtendedColorPaletteRawImpl(224, "MistyRose1");
  static const Thistle1 = AnsiExtendedColorPaletteRawImpl(225, "Thistle1");
  static const Yellow1 = AnsiExtendedColorPaletteRawImpl(226, "Yellow1");
  static const LightGoldenrod1 = AnsiExtendedColorPaletteRawImpl(227, "LightGoldenrod1");
  static const Khaki1 = AnsiExtendedColorPaletteRawImpl(228, "Khaki1");
  static const Wheat1 = AnsiExtendedColorPaletteRawImpl(229, "Wheat1");
  static const Cornsilk1 = AnsiExtendedColorPaletteRawImpl(230, "Cornsilk1");
  static const Grey100 = AnsiExtendedColorPaletteRawImpl(231, "Grey100");
  static const Grey3 = AnsiExtendedColorPaletteRawImpl(232, "Grey3");
  static const Grey7 = AnsiExtendedColorPaletteRawImpl(233, "Grey7");
  static const Grey11 = AnsiExtendedColorPaletteRawImpl(234, "Grey11");
  static const Grey15 = AnsiExtendedColorPaletteRawImpl(235, "Grey15");
  static const Grey19 = AnsiExtendedColorPaletteRawImpl(236, "Grey19");
  static const Grey23 = AnsiExtendedColorPaletteRawImpl(237, "Grey23");
  static const Grey27 = AnsiExtendedColorPaletteRawImpl(238, "Grey27");
  static const Grey30 = AnsiExtendedColorPaletteRawImpl(239, "Grey30");
  static const Grey35 = AnsiExtendedColorPaletteRawImpl(240, "Grey35");
  static const Grey39 = AnsiExtendedColorPaletteRawImpl(241, "Grey39");
  static const Grey42 = AnsiExtendedColorPaletteRawImpl(242, "Grey42");
  static const Grey46 = AnsiExtendedColorPaletteRawImpl(243, "Grey46");
  static const Grey50 = AnsiExtendedColorPaletteRawImpl(244, "Grey50");
  static const Grey54 = AnsiExtendedColorPaletteRawImpl(245, "Grey54");
  static const Grey58 = AnsiExtendedColorPaletteRawImpl(246, "Grey58");
  static const Grey62 = AnsiExtendedColorPaletteRawImpl(247, "Grey62");
  static const Grey66 = AnsiExtendedColorPaletteRawImpl(248, "Grey66");
  static const Grey70 = AnsiExtendedColorPaletteRawImpl(249, "Grey70");
  static const Grey74 = AnsiExtendedColorPaletteRawImpl(250, "Grey74");
  static const Grey78 = AnsiExtendedColorPaletteRawImpl(251, "Grey78");
  static const Grey82 = AnsiExtendedColorPaletteRawImpl(252, "Grey82");
  static const Grey85 = AnsiExtendedColorPaletteRawImpl(253, "Grey85");
  static const Grey89 = AnsiExtendedColorPaletteRawImpl(254, "Grey89");
  static const Grey93 = AnsiExtendedColorPaletteRawImpl(biggestNumberExtendedPalette, "Grey93");

  static const all = [
    Black,
    Maroon,
    Green,
    Olive,
    Navy,
    Purple,
    Teal,
    Silver,
    Grey,
    Red,
    Lime,
    Yellow,
    Blue,
    Fuchsia,
    Aqua,
    White,
    Grey0,
    NavyBlue,
    DarkBlue,
    Blue3,
    Blue3_2,
    Blue1,
    DarkGreen,
    DeepSkyBlue4,
    DeepSkyBlue4_2,
    DeepSkyBlue4_3,
    DodgerBlue3,
    DodgerBlue2,
    Green4,
    SpringGreen4,
    Turquoise4,
    DeepSkyBlue3,
    DeepSkyBlue3_2,
    DodgerBlue1,
    Green3,
    SpringGreen3,
    DarkCyan,
    LightSeaGreen,
    DeepSkyBlue2,
    DeepSkyBlue1,
    Green3_2,
    SpringGreen3_2,
    SpringGreen2,
    Cyan3,
    DarkTurquoise,
    Turquoise2,
    Green1,
    SpringGreen2_2,
    SpringGreen1,
    MediumSpringGreen,
    Cyan2,
    Cyan1,
    DarkRed,
    DeepPink4,
    Purple4,
    Purple4_2,
    Purple3,
    BlueViolet,
    Orange4,
    Grey37,
    MediumPurple4,
    SlateBlue3,
    SlateBlue3_2,
    RoyalBlue1,
    Chartreuse4,
    DarkSeaGreen4,
    PaleTurquoise4,
    SteelBlue,
    SteelBlue3,
    CornflowerBlue,
    Chartreuse3,
    DarkSeaGreen4_2,
    CadetBlue,
    CadetBlue_2,
    SkyBlue3,
    SteelBlue1,
    Chartreuse3_2,
    PaleGreen3,
    SeaGreen3,
    Aquamarine3,
    MediumTurquoise,
    SteelBlue1_2,
    Chartreuse2,
    SeaGreen2,
    SeaGreen1,
    SeaGreen1_2,
    Aquamarine1,
    DarkSlateGray2,
    DarkRed_2,
    DeepPink4_2,
    DarkMagenta,
    DarkMagenta_2,
    DarkViolet,
    Purple_2,
    Orange4_2,
    LightPink4,
    Plum4,
    MediumPurple3,
    MediumPurple3_2,
    SlateBlue1,
    Yellow4,
    Wheat4,
    Grey53,
    LightSlateGrey,
    MediumPurple,
    LightSlateBlue,
    Yellow4_2,
    DarkOliveGreen3,
    DarkSeaGreen,
    LightSkyBlue3,
    LightSkyBlue3_2,
    SkyBlue2,
    Chartreuse2_2,
    DarkOliveGreen3_2,
    PaleGreen3_2,
    DarkSeaGreen3,
    DarkSlateGray3,
    SkyBlue1,
    Chartreuse1,
    LightGreen,
    LightGreen_2,
    PaleGreen1,
    Aquamarine1_2,
    DarkSlateGray1,
    Red3,
    DeepPink4_3,
    MediumVioletRed,
    Magenta3,
    DarkViolet_2,
    Purple_3,
    DarkOrange3,
    IndianRed,
    HotPink3,
    MediumOrchid3,
    MediumOrchid,
    MediumPurple2,
    DarkGoldenrod,
    LightSalmon3,
    RosyBrown,
    Grey63,
    MediumPurple2_2,
    MediumPurple1,
    Gold3,
    DarkKhaki,
    NavajoWhite3,
    Grey69,
    LightSteelBlue3,
    LightSteelBlue,
    Yellow3,
    DarkOliveGreen3_3,
    DarkSeaGreen3_2,
    DarkSeaGreen2,
    LightCyan3,
    LightSkyBlue1,
    GreenYellow,
    DarkOliveGreen2,
    PaleGreen1_2,
    DarkSeaGreen2_2,
    DarkSeaGreen1,
    PaleTurquoise1,
    Red3_2,
    DeepPink3,
    DeepPink3_2,
    Magenta3_2,
    Magenta3_3,
    Magenta2,
    DarkOrange3_2,
    IndianRed_2,
    HotPink3_2,
    HotPink2,
    Orchid,
    MediumOrchid1,
    Orange3,
    LightSalmon3_2,
    LightPink3,
    Pink3,
    Plum3,
    Violet,
    Gold3_2,
    LightGoldenrod3,
    Tan,
    MistyRose3,
    Thistle3,
    Plum2,
    Yellow3_2,
    Khaki3,
    LightGoldenrod2,
    LightYellow3,
    Grey84,
    LightSteelBlue1,
    Yellow2,
    DarkOliveGreen1,
    DarkOliveGreen1_2,
    DarkSeaGreen1_2,
    Honeydew2,
    LightCyan1,
    Red1,
    DeepPink2,
    DeepPink1,
    DeepPink1_2,
    Magenta2_2,
    Magenta1,
    OrangeRed1,
    IndianRed1,
    IndianRed1_2,
    HotPink,
    HotPink_2,
    MediumOrchid1_2,
    DarkOrange,
    Salmon1,
    LightCoral,
    PaleVioletRed1,
    Orchid2,
    Orchid1,
    Orange1,
    SandyBrown,
    LightSalmon1,
    LightPink1,
    Pink1,
    Plum1,
    Gold1,
    LightGoldenrod2_2,
    LightGoldenrod2_3,
    NavajoWhite1,
    MistyRose1,
    Thistle1,
    Yellow1,
    LightGoldenrod1,
    Khaki1,
    Wheat1,
    Cornsilk1,
    Grey100,
    Grey3,
    Grey7,
    Grey11,
    Grey15,
    Grey19,
    Grey23,
    Grey27,
    Grey30,
    Grey35,
    Grey39,
    Grey42,
    Grey46,
    Grey50,
    Grey54,
    Grey58,
    Grey62,
    Grey66,
    Grey70,
    Grey74,
    Grey78,
    Grey82,
    Grey85,
    Grey89,
    Grey93,
  ];
}

abstract class NamedAnsiColor implements AnsiForegroundBackgroundColor, NamedAnsiBasicColor, AnsiColorName {}

abstract class NamedAnsiBasicColor implements AnsiBasicPalette, AnsiColorName {}

abstract class NamedAnsiExtendedColor implements AnsiExtendedColorPalette, AnsiColorName {}

abstract class AnsiColorName {
  /// A human readable name.
  String get name;
}

class AnsiExtendedColorPaletteRawImpl implements NamedAnsiExtendedColor {
  @override
  final int paletteNumberByte;
  @override
  final String name;

  const AnsiExtendedColorPaletteRawImpl(this.paletteNumberByte, this.name)
      : assert(
  paletteNumberByte >= byteStart && paletteNumberByte <= byteSize,
  'Color must be a value between 0 and 255.',
  );
}

abstract class NamedAnsiColors {
  static const black = NamedAnsiColorBlackImpl._();
  static const red = NamedAnsiColorRedImpl._();
  static const green = NamedAnsiColorGreenImpl._();
  static const yellow = NamedAnsiColorYellowImpl._();
  static const blue = NamedAnsiColorBlueImpl._();
  static const magenta = NamedAnsiColorMagentaImpl._();
  static const cyan = NamedAnsiColorCyanImpl._();
  static const white = NamedAnsiColorWhiteImpl._();
}

class NamedAnsiColorBlackImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorBlackImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteBlackTribit;

  @override
  String get name => defaultPaletteBlackName;
}

class NamedAnsiColorRedImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorRedImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteRedTribit;

  @override
  String get name => defaultPaletteRedName;
}

class NamedAnsiColorGreenImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorGreenImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteGreenTribit;

  @override
  String get name => defaultPaletteGreenName;
}

class NamedAnsiColorYellowImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorYellowImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteYellowTribit;

  @override
  String get name => defaultPaletteYellowName;
}

class NamedAnsiColorBlueImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorBlueImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteBlueTribit;

  @override
  String get name => defaultPaletteBlueName;
}

class NamedAnsiColorMagentaImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorMagentaImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteMagentaTribit;

  @override
  String get name => defaultPaletteMagentaName;
}

class NamedAnsiColorCyanImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorCyanImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteCyanTribit;

  @override
  String get name => defaultPaletteCyanName;
}

class NamedAnsiColorWhiteImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorWhiteImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteWhiteTribit;

  @override
  String get name => defaultPaletteWhiteName;
}

abstract class NamedAnsiColorsMore {
  static const allDark = [
    DarkAnsiColorAdapter(NamedAnsiColors.black),
    DarkAnsiColorAdapter(NamedAnsiColors.red),
    DarkAnsiColorAdapter(NamedAnsiColors.green),
    DarkAnsiColorAdapter(NamedAnsiColors.yellow),
    DarkAnsiColorAdapter(NamedAnsiColors.blue),
    DarkAnsiColorAdapter(NamedAnsiColors.magenta),
    DarkAnsiColorAdapter(NamedAnsiColors.cyan),
    DarkAnsiColorAdapter(NamedAnsiColors.white),
  ];
  static const allBright = [
    BrightAnsiColorAdapter(NamedAnsiColors.black),
    BrightAnsiColorAdapter(NamedAnsiColors.red),
    BrightAnsiColorAdapter(NamedAnsiColors.green),
    BrightAnsiColorAdapter(NamedAnsiColors.yellow),
    BrightAnsiColorAdapter(NamedAnsiColors.blue),
    BrightAnsiColorAdapter(NamedAnsiColors.magenta),
    BrightAnsiColorAdapter(NamedAnsiColors.cyan),
    BrightAnsiColorAdapter(NamedAnsiColors.white),
  ];
  static const allDarkAndBright = [...allDark, ...allBright];
}

class DarkAnsiColorAdapter implements NamedAnsiColor {
  final NamedAnsiBasicColor color;

  const DarkAnsiColorAdapter(this.color);

  @override
  int get backgroundColorCode => 40 + color.paletteNumberTribit;

  @override
  int get foregroundColorCode => 30 + color.paletteNumberTribit;

  @override
  int get paletteNumberTribit => color.paletteNumberTribit;

  @override
  String get name => color.name;
}

class BrightAnsiColorAdapter implements NamedAnsiColor {
  final NamedAnsiBasicColor color;

  const BrightAnsiColorAdapter(this.color);

  @override
  int get backgroundColorCode => 100 + color.paletteNumberTribit;

  @override
  int get foregroundColorCode => 90 + color.paletteNumberTribit;

  @override
  int get paletteNumberTribit => color.paletteNumberTribit;

  @override
  String get name => "bright " + color.name;
}
