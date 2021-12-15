import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/impl/coordinate.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';
import 'package:test/test.dart';

import '../example/readme.dart' as readme_example;

void main() {
  test("Coordinate positioning", () {
    final console = SneathConsoleImpl(autoSneathTerminal());
    const coordinate = SneathCoordinateImpl(5, 8);
    console.cursorPosition.update(coordinate);
    final returnedCoordinate = console.cursorPosition.get()!;
    expect(coordinate.row, equals(returnedCoordinate.row));
    expect(coordinate.col, equals(returnedCoordinate.col));
  });
  test("shouldn't throw while running the readme example", () {
    readme_example.main();
  });
}
