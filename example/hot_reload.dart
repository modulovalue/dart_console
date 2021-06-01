import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/interface/text_alignments.dart';
import 'package:dart_console/scaffolds/progress.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

import 'util/hot_reload.dart';

void main() => runApp(MyApp().update);

class MyApp {
  final progressScaffoldState = ProgressScaffoldState();

  void update() {
    final console = SneathConsoleImpl(autodetectSneathTerminal());
    const ProgressScaffold(
      title: "An optional title",
    ).run(progressScaffoldState, console);
    console.writeLine("... Searching ...", TextAlignment.center);
    console.resetColorAttributes();
  }
}
