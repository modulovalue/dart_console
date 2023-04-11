// Multiple choice quiz demonstrating various console features.
import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/prompt.dart';

void main() {
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  const dart_people = [
    'Dan Grove',
    'Michael Thomsen',
    'Leaf Petersen',
    'Bob Nystrom',
    'Vyacheslav Egorov',
    'Kathy Walrath',
  ];
  [
    Question(
      'What conference was Dart released at?',
      'GOTO Conference',
      choices: ['Google I/O', 'GOTO Conference', 'JavaOne', 'Dart Summit'],
    ),
    Question(
      'Who is a Product Manager for Dart at Google?',
      'Michael Thomsen',
      choices: dart_people,
    ),
    Question(
      'What is the package manager for Dart called?',
      'pub',
    ),
    Question(
      'What type of execution model does Dart have?',
      'Event Loop',
      choices: ['Multi Threaded', 'Single Threaded', 'Event Loop'],
    ),
    Question(
      'Does Dart have an interface keyword?',
      false,
    ),
    Question(
      'Is this valid Dart code?\n  main() => print(\"Hello World\");\nAnswer: ',
      true,
    ),
    Question(
      'Is this valid Dart code?\n  void main() => print(\"Hello World\");\nAnswer: ',
      true,
    ),
    Question(
      'Can you use Dart in the browser?',
      true,
    ),
    Question(
      'What was the first Dart to JavaScript Compiler called?',
      'dartc',
    ),
    Question(
      'Before dart2js, what was the name of the Dart to JavaScript Compiler?',
      'frog',
    ),
  ].forEach(
    (final q) {
      question_count++;
      final correct = q.ask_question(console);
      if (correct) {
        print('Correct');
        points++;
      } else {
        print('Incorrect');
      }
    },
  );
  results();
}

void results() {
  print('Quiz Results:');
  print('  Correct: $points');
  print('  Incorrect: ${question_count - points}');
  print('  Score: ${((points / question_count) * 100).toStringAsFixed(2)}%');
}

List<String> scramble(
  final List<String> choices,
) {
  final out = List<String>.from(choices);
  out.shuffle();
  return out;
}

int question_count = 0;
int points = 0;

class Question {
  final String message;
  final dynamic answer;
  final List<String>? choices;

  Question(
    final this.message,
    final this.answer, {
    final this.choices,
  });

  bool ask_question(
    final DCConsole console,
  ) {
    if (choices != null) {
      print(message);
      final chooser = DCChooser<String>(
        console,
        scramble(choices!),
        message: 'Answer: ',
      );
      return chooser.chooseSync() == answer;
    } else {
      final dynamic _answer = answer;
      if (_answer is String) {
        return DCPrompter(
              console: console,
              message: '$message ',
            ).prompt_sync()?.toLowerCase().trim() ==
            _answer.toLowerCase().trim();
      } else if (_answer is bool) {
        return DCPrompter(
              console: console,
              message: '$message ',
            ).ask_sync() ==
            _answer;
      } else {
        throw Exception('');
      }
    }
  }
}
