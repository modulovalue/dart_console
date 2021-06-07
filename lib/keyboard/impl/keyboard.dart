import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../ansi/spec/csi.dart';
import '../../ansi/spec/escape.dart';
import '../../ansi/spec/lib.dart';
import '../interface/keyboard.dart';

class TerminalKeyboardImpl implements TerminalKeyboard {
  final Stream<List<int>> byteStream;
  final void Function() moveCursorBackByOne;
  final Map<String, StreamController<String>> _handlers = {};
  final List<StreamController<String>> bound = [];

  late final StreamSubscription<List<int>> _subscription;

  /// Display input that is not handled.
  bool echoUnhandledKeys = true;

  TerminalKeyboardImpl({
    required this.byteStream,
    required this.moveCursorBackByOne,
  }) {
    stdin.echoMode = false;
    stdin.lineMode = false;
    _subscription = byteStream.asBroadcastStream().listen((bytes) {
      final it = ascii.decode(bytes);
      final original = bytes;
      var code = it.replaceAll(ansiEscape, '');
      if (code.isNotEmpty) {
        code = code.substring(1);
      }
      if (inputSequences[code] != null) {
        return handleKey(original, inputSequences[code]);
      } else {
        return handleKey(original, it);
      }
    });
  }

  static final _stdin = stdin.asBroadcastStream();

  factory TerminalKeyboardImpl.stdin() => TerminalKeyboardImpl(
        byteStream: _stdin,
        moveCursorBackByOne: () => stdout.write(controlSequenceIdentifier + '1D'),
      );

  @override
  void destroy() {
    for (final controller in _handlers.values) {
      controller.close();
    }
    _handlers.clear();
    for (final b in bound) {
      b.close();
    }
    bound.clear();
    _subscription.cancel();
  }

  @override
  void handleKey(List<int>? bytes, String? name) {
    if (name != null) {
      if (_handlers.containsKey(name)) {
        _handlers[name]!.add(name);
      } else {
        if (echoUnhandledKeys) {
          if (bytes != null) {
            if (bytes.length == 1 && bytes.single == 127) {
              if (Platform.isMacOS) {
                moveCursorBackByOne();
              } else {
                stdout.write('\b \b');
                return;
              }
            }
            stdout.add(bytes);
            if (bytes.length == 1 && bytes.single == 127) {
              moveCursorBackByOne();
            }
          }
        }
      }
    }
  }

  @override
  Stream<String> bindKey(String code) {
    if (_handlers.containsKey(code)) {
      return _handlers[code]!.stream;
    } else {
      return (_handlers[code] = StreamController<String>.broadcast()).stream;
    }
  }

  @override
  Stream<String> bindKeys(List<String> codes) {
    final controller = StreamController<String>.broadcast();
    bound.add(controller);
    for (final key in codes) {
      bindKey(key).listen(controller.add);
    }
    return controller.stream;
  }
}
