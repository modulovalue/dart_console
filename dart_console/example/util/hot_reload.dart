import 'package:dart_console/util/call_periodically.dart';
import 'package:hotreloader/hotreloader.dart';

void runApp(void Function() updateWindow) => //
    callPeriodicallyWithHotReload(
      routine: updateWindow,
      wrapper: HotReload,
    );

const HotReloadFactoryImpl HotReload = HotReloadFactoryImpl();

class HotReloadFactoryImpl {
  const HotReloadFactoryImpl();

  void call(void Function() onChange) => //
      simple(onChange);

  void simple(void Function() onChange) => //
      debounced(Duration.zero, onChange);

  void debounced(Duration d, void Function() onChange) {
    onChange();
    HotReloader.create(
      debounceInterval: d,
      onBeforeReload: (_) {
        print("Reloading... ${DateTime.now()}");
        return true;
      },
      onAfterReload: (_) {
        print("Reloaded! ${DateTime.now()}");
        onChange();
      },
    );
  }
}
