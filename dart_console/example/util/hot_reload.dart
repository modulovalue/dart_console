import 'package:dart_console/util/call_periodically.dart';
import 'package:hotreloader/hotreloader.dart';

void runApp(
  final void Function() update_window,
) {
  call_periodically_with_hot_reload(
    routine: update_window,
    wrapper: HotReload.simple,
  );
}

const HotReloadFactoryImpl HotReload = HotReloadFactoryImpl();

class HotReloadFactoryImpl {
  const HotReloadFactoryImpl();

  void simple(
    final void Function() on_change,
  ) {
    debounced(
      Duration.zero,
      on_change,
    );
  }

  void debounced(
    final Duration d,
    final void Function() on_change,
  ) {
    on_change();
    HotReloader.create(
      debounceInterval: d,
      onBeforeReload: (final _) {
        print("Reloading... " + DateTime.now().toString());
        return true;
      },
      onAfterReload: (final _) {
        print("Reloaded! " + DateTime.now().toString());
        on_change();
      },
    );
  }
}
