import 'package:dart_console/console/alignment.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/scaffolds/progress.dart';
import 'package:dart_console/terminal/terminal_lib_auto.dart';

import 'util/hot_reload.dart';

// Run with 'dart --enable-vm-service example/hot_reload.dart'
void main() => runApp(
      MyApp().update,
    );

class MyApp {
  final ProgressScaffoldState progressScaffoldState = progressScaffoldStateNow(
    title: "An optional title",
    subtitle: "An optional subtitle",
  );

  MyApp();

  void update() {
    final console = SneathConsoleImpl(
      terminal: autoSneathTerminal(),
    );
    runProgressScaffold(
      state: progressScaffoldState,
      console: console,
    );
    console.writeLine("... Searching ...", ConsoleTextAlignments.center);
    console.resetColorAttributes();
  }
}
