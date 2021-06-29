import 'dart:async';

import 'base.dart';

/// A timer display that mimics pub's timer.
class DCTimeDisplay {
  Stopwatch? _watch;
  bool _isStart = true;
  late String _lastMsg;
  Timer? _updateTimer;
  final DCConsole console;

  DCTimeDisplay(this.console);

  /// Starts the Timer
  void start([int place = 1]) {
    console.rawConsole.echoMode = false;
    _watch = Stopwatch();
    _updateTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      update(place);
    });
    _watch!.start();
  }

  /// Stops the Timer
  void stop() {
    console.rawConsole.echoMode = true;
    if (_watch != null) {
      _watch!.stop();
    }
    if (_updateTimer != null) {
      _updateTimer!.cancel();
    }
  }

  /// Updates the Timer
  void update([int place = 1]) {
    if (_watch != null) {
      if (_isStart) {
        final msg = '(${_watch!.elapsed.inSeconds}s)';
        _lastMsg = msg;
        console.rawConsole.write(msg);
        _isStart = false;
      } else {
        console.moveCursorBack(_lastMsg.length);
        final msg = '(${(_watch!.elapsed.inMilliseconds / 1000).toStringAsFixed(place)}s)';
        _lastMsg = msg;
        console.rawConsole.write(msg);
      }
    }
  }
}
