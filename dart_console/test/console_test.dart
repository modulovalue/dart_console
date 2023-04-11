import 'package:dart_console/console/impl.dart';
import 'package:dart_console/terminal/terminal_lib_auto.dart';
import 'package:test/test.dart';

import '../example/readme.dart' as readme_example;

void main() {
  test("Coordinate positioning", () {
    final console = SneathConsoleImpl(
      terminal: auto_sneath_terminal(),
    );
    const coordinate = SneathCoordinateImpl(
      row: 5,
      col: 8,
    );
    console.cursor_position.update(coordinate);
    final returned_coordinate = console.cursor_position.get()!;
    expect(coordinate.row, equals(returned_coordinate.row));
    expect(coordinate.col, equals(returned_coordinate.col));
  });
  test("shouldn't throw while running the readme example", () {
    readme_example.main();
  });
}
