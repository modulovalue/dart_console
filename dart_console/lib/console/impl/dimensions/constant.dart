import 'dart:io';

import 'package:dart_ansi/ansi.dart';

import '../../../terminal/interface/terminal_lib.dart';
import '../../interface/cursor_position.dart';
import '../../interface/dimensions.dart';

/// A [SneathConsoleDimensions] that caches the dimensions
/// the first time that they are retrieved.
class SneathConsoleDimensionsCachedImpl implements SneathConsoleDimensions {
  final SneathCursorPositionDelegate cursorPosition;
  final SneathTerminal _terminal;

  int? _width;
  int? _height;

  SneathConsoleDimensionsCachedImpl(this._terminal, this.cursorPosition);

  @override
  int get width {
    if (_width == null) {
      // try using ioctl() to give us the screen size
      final width = _terminal.getWindowWidth();
      if (width != -1) {
        _width = width;
      } else {
        // otherwise, fall back to the approach of setting the cursor to beyond
        // the edge of the screen and then reading back its actual position
        final originalCursor = cursorPosition.get();
        stdout.write(ansiMoveCursorToScreenEdge);
        final newCursor = cursorPosition.get();
        cursorPosition.update(originalCursor);
        if (newCursor != null) {
          _width = newCursor.col;
        } else {
          // we've run out of options; terminal is unsupported
          throw const SneathConsoleDimensionsExceptionImpl("Couldn't retrieve window width");
        }
      }
      return _width!;
    } else {
      return _width!;
    }
  }

  @override
  int get height {
    if (_height == null) {
      // try using ioctl() to give us the screen size
      final height = _terminal.getWindowHeight();
      if (height != -1) {
        _height = height;
      } else {
        // otherwise, fall back to the approach of setting the cursor to beyond
        // the edge of the screen and then reading back its actual position
        final originalCursor = cursorPosition.get();
        stdout.write(ansiMoveCursorToScreenEdge);
        final newCursor = cursorPosition.get();
        cursorPosition.update(originalCursor);
        if (newCursor != null) {
          _height = newCursor.row;
        } else {
          // we've run out of options; terminal is unsupported
          throw const SneathConsoleDimensionsExceptionImpl("Couldn't retrieve window height");
        }
      }
      return _height!;
    } else {
      return _height!;
    }
  }
}

class SneathConsoleDimensionsExceptionImpl implements SneathConsoleDimensionsException {
  @override
  final String message;

  const SneathConsoleDimensionsExceptionImpl(this.message);

  @override
  String toString() => 'SneathConsoleDimensionsExceptionImpl{message: $message}';
}
