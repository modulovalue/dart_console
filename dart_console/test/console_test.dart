import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/impl/coordinate.dart';
import 'package:dart_console/terminal/terminal_lib_auto.dart';
import 'package:test/test.dart';

import '../example/readme.dart' as readme_example;

void main() {
  test("Coordinate positioning", () {
    final console = SneathConsoleImpl(
      terminal: autoSneathTerminal(),
    );
    const coordinate = SneathCoordinateImpl(row: 5, col: 8);
    console.cursorPosition.update(coordinate);
    final returnedCoordinate = console.cursorPosition.get()!;
    expect(coordinate.row, equals(returnedCoordinate.row));
    expect(coordinate.col, equals(returnedCoordinate.col));
  });
  test("shouldn't throw while running the readme example", () {
    readme_example.main();
  });
}
