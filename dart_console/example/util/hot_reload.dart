import 'package:dart_console/util/call_periodically.dart';
import 'package:hotreloader/hotreloader.dart';

void runApp(
  final void Function() updateWindow,
) =>
    callPeriodicallyWithHotReload(
      routine: updateWindow,
      wrapper: HotReload,
    );

const HotReloadFactoryImpl HotReload = HotReloadFactoryImpl();

class HotReloadFactoryImpl {
  const HotReloadFactoryImpl();

  void call(
    final void Function() onChange,
  ) =>
      simple(onChange);

  void simple(
    final void Function() onChange,
  ) =>
      debounced(Duration.zero, onChange);

  void debounced(
    final Duration d,
    final void Function() onChange,
  ) {
    onChange();
    HotReloader.create(
      debounceInterval: d,
      onBeforeReload: (final _) {
        print("Reloading... ${DateTime.now()}");
        return true;
      },
      onAfterReload: (final _) {
        print("Reloaded! ${DateTime.now()}");
        onChange();
      },
    );
  }
}
