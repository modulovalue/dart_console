import 'package:dart_console3/console/impl.dart';
import 'package:dart_console3/console/interface.dart';
import 'package:dart_console3/scaffolds/progress.dart';
import 'package:dart_console3/terminal/terminal_lib_auto.dart';

import 'util/hot_reload.dart';

// Run with 'dart --enable-vm-service example/hot_reload.dart'
void main() {
  runApp(
    MyApp().update,
  );
}

class MyApp {
  final ProgressScaffoldState progress_scaffold_state =
      progress_scaffold_state_now(
    title: "An optional title",
    subtitle: "An optional subtitle",
  );

  MyApp();

  void update() {
    final console = SneathConsoleImpl(
      terminal: auto_sneath_terminal(),
    );
    run_progress_scaffold(
      state: progress_scaffold_state,
      console: console,
    );
    console.write_line("... Searching ...", ConsoleTextAlignments.center);
    console.reset_color_attributes();
  }
}
