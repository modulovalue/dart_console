/// Platform-independent library for interrogating and manipulating the console.
///
/// This class provides raw wrappers for the underlying terminal system calls
/// that are not available through ANSI mode control sequences, and is not
/// designed to be called directly.
abstract class SneathTerminal {
  /// Returns the height of the terminal window.
  int get_window_height();

  /// Returns the width of the terminal window.
  int get_window_width();

  /// See console 'set rawmode' for an explanation of raw mode.
  void enable_raw_mode();

  /// See console 'set rawmode' for an explanation of raw mode.
  void disable_raw_mode();

  /// Clears the terminal screen.
  void clear_screen();

  /// Positions the cursor at the given [column] and [row].
  void set_cursor_position(
    final int column,
    final int row,
  );
}
