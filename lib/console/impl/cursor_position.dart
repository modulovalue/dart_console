import 'dart:io';

import '../../ansi/impl/ansi.dart';
import '../../terminal/interface/terminal_lib.dart';
import '../interface/coordinate.dart';
import '../interface/cursor_position.dart';
import 'coordinate.dart';

class SneathCursorPositionDelegateImpl implements SneathCursorPositionDelegate {
  final SneathTerminal terminal;
  final void Function(bool) setRawModeDelegate;

  const SneathCursorPositionDelegateImpl(this.terminal, this.setRawModeDelegate);

  @override
  SneathCoordinate? get() {
    setRawModeDelegate(true);
    stdout.write(AnsiConstants.ansiDeviceStatusReportCursorPosition);
    // returns a Cursor Position Report result in the form <ESC>[24;80R
    // which we have to parse apart, unfortunately
    var result = '';
    var i = 0;
    // avoid infinite loop if we're getting a bad result
    while (i < 16) {
      // ignore: use_string_buffers
      result += String.fromCharCode(stdin.readByteSync());
      if (result.endsWith('R')) {
        break;
      }
      i++;
    }
    setRawModeDelegate(false);
    if (result[0] != AnsiConstants.escape) {
      print(' result: $result  result.length: ${result.length}');
      return null;
    } else {
      result = result.substring(2, result.length - 1);
      final coords = result.split(';');
      if (coords.length != 2) {
        print(' coords.length: ${coords.length}');
        return null;
      } else {
        final parsedX = int.tryParse(coords[0]);
        final parsedY = int.tryParse(coords[1]);
        if ((parsedX != null) && (parsedY != null)) {
          return SneathCoordinateImpl(parsedX - 1, parsedY - 1);
        } else {
          print(' coords[0]: ${coords[0]}   coords[1]: ${coords[1]}');
          return null;
        }
      }
    }
  }

  @override
  void update(SneathCoordinate? cursor) {
    if (cursor != null) {
      terminal.setCursorPosition(cursor.col, cursor.row);
    }
  }
}
