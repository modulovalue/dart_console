import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/impl/coordinate.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';
import 'package:test/test.dart';

import '../example/readme.dart' as readme_example;

void main() {
  test('Coordinate positioning', () {
    final console = SneathConsoleImpl(autodetectSneathTerminal());
    const coordinate = CoordinateImpl(5, 8);
    console.cursorPosition = coordinate;
    final returnedCoordinate = console.cursorPosition!;
    expect(coordinate.row, equals(returnedCoordinate.row));
    expect(coordinate.col, equals(returnedCoordinate.col));
  });
  test('should throw while running the readme example', () {
    readme_example.main();
  });
}
