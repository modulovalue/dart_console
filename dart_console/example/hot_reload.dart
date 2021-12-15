import 'package:dart_console/console/alignment.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/scaffolds/progress.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

import 'util/hot_reload.dart';

void main() => runApp(MyApp().update);

class MyApp {
  final ProgressScaffoldState progressScaffoldState = ProgressScaffoldState(
    title: "An optional title",
  );

  MyApp();

  void update() {
    final console = SneathConsoleImpl(autoSneathTerminal());
    runProgressScaffold(
      state: progressScaffoldState,
      console: console,
    );
    console.writeLine("... Searching ...", ConsoleTextAlignments.center);
    console.resetColorAttributes();
  }
}
