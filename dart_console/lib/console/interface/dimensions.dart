abstract class SneathConsoleDimensions {
  /// Returns the width of the current console window in characters.
  ///
  /// This command attempts to use the ioctl() system call to retrieve the
  /// window width, and if that fails uses ANSI escape codes to identify its
  /// location by walking off the edge of the screen and seeing what the
  /// terminal clipped the cursor to.
  ///
  /// If unable to retrieve a valid width from either method, the method
  /// throws an [SneathConsoleDimensionsException].
  int get width;

  /// Returns the height of the current console window in characters.
  ///
  /// This command attempts to use the ioctl() system call to retrieve the
  /// window height, and if that fails uses ANSI escape codes to identify its
  /// location by walking off the edge of the screen and seeing what the
  /// terminal clipped the cursor to.
  ///
  /// If unable to retrieve a valid height from either method, the method
  /// throws an [SneathConsoleDimensionsException].
  int get height;
}

abstract class SneathConsoleDimensionsException implements Exception {
  String get message;
}
