/// Platform-independent library for interrogating and manipulating the console.
///
/// This class provides raw wrappers for the underlying terminal system calls
/// that are not available through ANSI mode control sequences, and is not
/// designed to be called directly. Package consumers should normally use the
/// `Console` class to call these methods.
abstract class SneathTerminal {
  /// Returns the height of the terminal window.
  int getWindowHeight();

  /// Returns the width of the terminal window.
  int getWindowWidth();

  /// See console 'set rawmode' for an explanation of raw mode.
  void enableRawMode();

  /// See console 'set rawmode' for an explanation of raw mode.
  void disableRawMode();

  /// Clears the terminal screen.
  void clearScreen();

  /// Positions the cursor at the given [column] and [row].
  void setCursorPosition(int column, int row);
}
