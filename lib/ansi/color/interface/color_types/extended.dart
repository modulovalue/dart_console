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
