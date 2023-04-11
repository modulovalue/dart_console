import 'dart:async';

import 'base.dart';

/// A timer display that mimics pub's timer.
class DCTimeDisplay {
  Stopwatch? _watch;
  bool _isStart = true;
  late String _lastMsg;
  Timer? _updateTimer;
  final DCConsole console;

  DCTimeDisplay({
    required final this.console,
  });

  /// Starts the Timer
  void start([
    final int place = 1,
  ]) {
    console.raw_console.echo_mode = false;
    _watch = Stopwatch();
    _updateTimer = Timer.periodic(
      const Duration(milliseconds: 10),
      (final timer) {
        update(place);
      },
    );
    _watch!.start();
  }

  /// Stops the Timer
  void stop() {
    console.raw_console.echo_mode = true;
    if (_watch != null) {
      _watch!.stop();
    }
    if (_updateTimer != null) {
      _updateTimer!.cancel();
    }
  }

  /// Updates the Timer
  void update([
    final int place = 1,
  ]) {
    if (_watch != null) {
      if (_isStart) {
        final msg = '(${_watch!.elapsed.inSeconds}s)';
        _lastMsg = msg;
        console.raw_console.write(msg);
        _isStart = false;
      } else {
        console.move_cursor_back(_lastMsg.length);
        final msg = '(${(_watch!.elapsed.inMilliseconds / 1000).toStringAsFixed(place)}s)';
        _lastMsg = msg;
        console.raw_console.write(msg);
      }
    }
  }
}
