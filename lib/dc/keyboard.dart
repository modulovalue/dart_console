import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../ansi/impl/ansi.dart';
import 'base.dart';

/// API for the keyboard.
class DCKeyboard {
  final DCConsole console;
  final Map<String, StreamController<String>> _handlers = {};

  bool _initialized = false;

  /// Display input that is not handled.
  bool echoUnhandledKeys = true;

  DCKeyboard(this.console);

  /// Initialize the keyboard system.
  void init() {
    if (!_initialized) {
      stdin.echoMode = false;
      stdin.lineMode = false;
      _initialized = true;
      console.rawConsole.byteStream().asBroadcastStream().map((bytes) {
        final it = ascii.decode(bytes);
        final original = bytes;
        var code = it.replaceAll(AnsiConstants.escape, '');
        if (code.isNotEmpty) {
          code = code.substring(1);
        }
        if (inputSequences[code] != null) {
          return _Tuple(original, inputSequences[code]);
        } else {
          return _Tuple(original, it);
        }
      }).listen((m) {
        handleKey(m.a, m.b);
      });
    }
  }

  void handleKey(List<int>? bytes, String? name) {
    if (name != null) {
      if (_handlers.containsKey(name)) {
        _handlers[name]!.add(name);
      } else {
        if (echoUnhandledKeys) {
          if (bytes != null) {
            if (bytes.length == 1 && bytes[0] == 127) {
              if (Platform.isMacOS) {
                console.moveCursorBack(1);
              } else {
                stdout.write('\b \b');
                return;
              }
            }
            stdout.add(bytes);
            if (bytes.length == 1 && bytes[0] == 127) {
              console.moveCursorBack(1);
            }
          }
        }
      }
    }
  }

  Stream<String> bindKey(String code) {
    init();
    if (_handlers.containsKey(code)) {
      return _handlers[code]!.stream;
    } else {
      // ignore: close_sinks
      final controller = StreamController<String>.broadcast();
      return (_handlers[code] = controller).stream;
    }
  }

  Stream<String> bindKeys(List<String> codes) {
    init();
    // ignore: close_sinks
    final controller = StreamController<String>.broadcast();
    for (final key in codes) {
      bindKey(key).listen(controller.add);
    }
    return controller.stream;
  }
}

class _Tuple {
  final List<int> a;
  final String? b;

  const _Tuple(this.a, this.b);
}
