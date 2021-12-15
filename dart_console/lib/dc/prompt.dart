import 'dart:async';

import 'base.dart';

/// Emulates a Shell Prompt
class DCShellPrompt {
  /// Shell Prompt
  String message;
  bool _stop = false;
  final DCConsole console;

  DCShellPrompt(
    final this.console, {
    final this.message = r'$ ',
  });

  /// Stops a Loop
  void stop() => _stop = true;

  /// Runs a shell prompt in a loop.
  Stream<String> loop() {
    // ignore: close_sinks
    final controller = StreamController<String>();
    late void Function() doRead;
    doRead = () {
      if (_stop) {
        _stop = false;
      } else {
        DCPrompter(console, message).prompt().then(
          (final it) {
            controller.add(it);
            Future<void>(doRead);
          },
        );
      }
    };
    Future<void>(doRead);
    return controller.stream;
  }
}

class DCChooser<T> {
  final String message;
  final List<T> choices;
  final String Function(T choice, int index) formatter;
  final DCConsole console;

  DCChooser(
    final this.console,
    final this.choices, {
    final this.message = 'Choice: ',
    final this.formatter = _defaultFormatter,
  });

  static String _defaultFormatter(
    final dynamic input,
    final int index,
  ) =>
      '[$index] $input';

  T chooseSync() {
    final buff = StringBuffer();
    var i = -1;
    for (final choice in choices) {
      i++;
      buff.writeln(formatter(choice, i + 1));
    }
    buff.write(message);
    for (;;) {
      final input = DCPrompter(console, buff.toString()).promptSync();
      final result = _parseInteger(input ?? '');
      if (result == null && input != null) {
        final exists = choices
            .map(
              (final it) => it.toString().trim().toLowerCase(),
            )
            .contains(
              input.trim().toLowerCase(),
            );
        if (exists) {
          final val = choices.firstWhere(
            (final it) {
              return it.toString().trim().toLowerCase() == input.trim().toLowerCase();
            },
          );
          return val;
        }
      }
      try {
        if (result != null) {
          return choices[result - 1];
        }
        // ignore: empty_catches, avoid_catches_without_on_clauses
      } catch (e) {}
    }
  }

  Future<dynamic> choose() {
    final buff = StringBuffer();
    var i = -1;
    for (final choice in choices) {
      i++;
      buff.writeln(formatter(choice, i + 1));
    }
    buff.write(message);
    final completer = Completer<T>();
    late void Function(String) process;
    process = (final String input) {
      final result = _parseInteger(input);
      if (result == null) {
        final exists = choices.map((it) => it.toString().trim().toLowerCase()).contains(input.trim().toLowerCase());
        if (exists) {
          final val = choices.firstWhere((it) {
            return it.toString().trim().toLowerCase() == input.trim().toLowerCase();
          });
          completer.complete(val);
          return;
        }
      }
      T choice;
      try {
        if (result == null) {
          DCPrompter(console, buff.toString()).prompt().then(process);
        } else {
          choice = choices[result - 1];
          completer.complete(choice);
        }
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        DCPrompter(console, buff.toString()).prompt().then(process);
      }
    };
    DCPrompter(console, buff.toString()).prompt().then(process);
    return completer.future;
  }
}

class DCPrompter {
  final String message;
  final bool secret;
  final DCConsole console;

  const DCPrompter(
    final this.console,
    final this.message, {
    final this.secret = false,
  });

  /// Prompts a user for a yes or no answer.
  ///
  /// The following are considered yes responses:
  ///
  /// - yes
  /// - y
  /// - sure
  /// - ok
  /// - yep
  /// - yeah
  /// - true
  /// - yerp
  ///
  /// You can add more to the list of positive responses using the [positive] argument.
  ///
  /// The input will be changed to lowercase and then checked.
  bool? askSync({
    final List<String> positive = const [],
  }) {
    final answer = promptSync();
    if (answer == null) {
      // ignore: avoid_returning_null
      return null;
    } else {
      return DC_YES_RESPONSES.contains(answer.toLowerCase()) || positive.contains(message.toLowerCase());
    }
  }

  Future<bool> ask({
    final List<String> positive = const [],
  }) {
    return prompt().then((answer) {
      return DC_YES_RESPONSES.contains(answer.toLowerCase()) || positive.contains(message.toLowerCase());
    });
  }

  static const List<String> DC_YES_RESPONSES = [
    'yes',
    'y',
    'sure',
    'ok',
    'yep',
    'yeah',
    'true',
    'yerp',
  ];

  String? promptSync({
    final bool Function(String response)? checker,
  }) {
    for (;;) {
      console.rawConsole.write(message);
      if (secret) {
        console.rawConsole.echoMode = false;
      }
      final response = console.rawConsole.read();
      if (secret) {
        console.rawConsole.echoMode = true;
        print('');
      }
      if (checker != null && response != null) {
        if (checker(response)) {
          return response;
        }
      } else {
        return response;
      }
    }
  }

  Future<String> prompt({
    final bool Function(String response)? checker,
  }) {
    final completer = Completer<String>();
    late void Function() doAsk;
    doAsk = () {
      console.rawConsole.write(message);
      Future(() {
        if (secret) {
          console.rawConsole.echoMode = false;
        }
        final response = console.rawConsole.read();
        if (secret) {
          console.rawConsole.echoMode = true;
        }
        if (checker != null && response != null && !checker(response)) {
          doAsk();
          return;
        }
        completer.complete(response);
      });
    };
    doAsk();
    return completer.future;
  }
}

Future<String> readInput(
  final DCConsole console,
  final String message, {
  final bool secret = false,
  final bool Function(String response)? checker,
}) =>
    DCPrompter(
      console,
      message,
      secret: secret,
    ).prompt(
      checker: checker,
    );

int? _parseInteger(
  final String input,
) =>
    int.tryParse(input);
