// Copyright 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;

import 'ansi.dart';

/// TODO

const _ansiEscapeForScript = '\\033';

/// Whether formatted ANSI output is enabled for [wrapWith] and [AnsiCode.wrap].
///
/// By default, returns `true` if both `stdout.supportsAnsiEscapes` and
/// `stderr.supportsAnsiEscapes` from `dart:io` are `true`.
///
/// The default can be overridden by setting the [Zone] variable [AnsiCode] to
/// either `true` or `false`.
///
/// [overrideAnsiOutput] is provided to make this easy.
bool get ansiOutputEnabled =>
    Zone.current[AnsiCode] as bool? ?? (io.stdout.supportsAnsiEscapes && io.stderr.supportsAnsiEscapes);

/// Returns `true` no formatting is required for [input].
bool _isNoop(
  final bool skip,
  final String? input,
  final bool? forScript,
) =>
    skip || input == null || input.isEmpty || !((forScript ?? false) || ansiOutputEnabled);

/// Allows overriding [ansiOutputEnabled] to [enableAnsiOutput] for the code run
/// within [body].
T overrideAnsiOutput<T>(
  final bool enableAnsiOutput,
  final T Function() body,
) =>
    runZoned(
      body,
      zoneValues: <Object, Object>{AnsiCode: enableAnsiOutput},
    );

/// The type of code represented by [AnsiCode].
class AnsiCodeType {
  final String _name;

  /// A foreground color.
  static const AnsiCodeType foreground = AnsiCodeType._('foreground');

  /// A style.
  static const AnsiCodeType style = AnsiCodeType._('style');

  /// A background color.
  static const AnsiCodeType background = AnsiCodeType._('background');

  /// A reset value.
  static const AnsiCodeType reset = AnsiCodeType._('reset');

  const AnsiCodeType._(this._name);

  @override
  String toString() => 'AnsiType.$_name';
}

/// Standard ANSI escape code for customizing terminal text output.
///
/// [Source](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)
class AnsiCode {
  /// The numeric value associated with this code.
  final int code;

  /// The [AnsiCode] that resets this value, if one exists.
  ///
  /// Otherwise, `null`.
  final AnsiCode? reset;

  /// A description of this code.
  final String name;

  /// The type of code that is represented.
  final AnsiCodeType type;

  const AnsiCode._(
    final this.name,
    final this.type,
    final this.code,
    final this.reset,
  );

  /// Represents the value escaped for use in terminal output.
  String get escape => '$ansiEscape[${code}m';

  /// Represents the value as an unescaped literal suitable for scripts.
  String get escapeForScript => '$_ansiEscapeForScript[${code}m';

  String _escapeValue({
    final bool forScript = false,
  }) {
    if (forScript) {
      return escapeForScript;
    } else {
      return escape;
    }
  }

  /// Wraps [value] with the [escape] value for this code, followed by
  /// [resetAll].
  ///
  /// If [forScript] is `true`, the return value is an unescaped literal. The
  /// value of [ansiOutputEnabled] is also ignored.
  ///
  /// Returns `value` unchanged if
  ///   * [value] is `null` or empty
  ///   * both [ansiOutputEnabled] and [forScript] are `false`.
  ///   * [type] is [AnsiCodeType.reset]
  String? wrap(
    final String? value, {
    final bool forScript = false,
  }) {
    if (_isNoop(type == AnsiCodeType.reset, value, forScript)) {
      return value;
    } else {
      return '${_escapeValue(forScript: forScript)}$value'
          '${reset!._escapeValue(forScript: forScript)}';
    }
  }

  @override
  String toString() => '$name ${type._name} ($code)';
}

/// Returns a [String] formatted with [codes].
///
/// If [forScript] is `true`, the return value is an unescaped literal. The
/// value of [ansiOutputEnabled] is also ignored.
///
/// Returns `value` unchanged if
///   * [value] is `null` or empty.
///   * both [ansiOutputEnabled] and [forScript] are `false`.
///   * [codes] is empty.
///
/// Throws an [ArgumentError] if
///   * [codes] contains more than one value of type [AnsiCodeType.foreground].
///   * [codes] contains more than one value of type [AnsiCodeType.background].
///   * [codes] contains any value of type [AnsiCodeType.reset].
String? wrapWith(
  final String? value,
  final Iterable<AnsiCode> codes, {
  final bool forScript = false,
}) {
  // Eliminate duplicates
  final myCodes = codes.toSet();
  if (_isNoop(myCodes.isEmpty, value, forScript)) {
    return value;
  } else {
    var foreground = 0, background = 0;
    for (final code in myCodes) {
      // ignore: exhaustive_cases
      switch (code.type) {
        case AnsiCodeType.foreground:
          foreground++;
          if (foreground > 1) {
            throw ArgumentError.value(
              codes,
              'codes',
              'Cannot contain more than one foreground color code.',
            );
          }
          break;
        case AnsiCodeType.background:
          background++;
          if (background > 1) {
            throw ArgumentError.value(
              codes,
              'codes',
              'Cannot contain more than one foreground color code.',
            );
          }
          break;
        case AnsiCodeType.reset:
          throw ArgumentError.value(
            codes,
            'codes',
            'Cannot contain reset codes.',
          );
      }
    }
    final sortedCodes = myCodes.map((final ac) => ac.code).toList()..sort();
    final escapeValue = () {
      if (forScript) {
        return _ansiEscapeForScript;
      } else {
        return ansiEscape;
      }
    }();
    return "$escapeValue[${sortedCodes.join(';')}m$value"
        '${resetAll._escapeValue(forScript: forScript)}';
  }
}

//
// Style values
//

const AnsiCode styleBold = AnsiCode._(
  'bold',
  AnsiCodeType.style,
  1,
  resetBold,
);
const AnsiCode styleDim = AnsiCode._(
  'dim',
  AnsiCodeType.style,
  2,
  resetDim,
);
const AnsiCode styleItalic = AnsiCode._(
  'italic',
  AnsiCodeType.style,
  3,
  resetItalic,
);
const AnsiCode styleUnderlined = AnsiCode._(
  'underlined',
  AnsiCodeType.style,
  4,
  resetUnderlined,
);
const AnsiCode styleBlink = AnsiCode._(
  'blink',
  AnsiCodeType.style,
  5,
  resetBlink,
);
const AnsiCode styleReverse = AnsiCode._(
  'reverse',
  AnsiCodeType.style,
  7,
  resetReverse,
);

/// Not widely supported.
const AnsiCode styleHidden = AnsiCode._(
  'hidden',
  AnsiCodeType.style,
  8,
  resetHidden,
);

/// Not widely supported.
const AnsiCode styleCrossedOut = AnsiCode._(
  'crossed out',
  AnsiCodeType.style,
  9,
  resetCrossedOut,
);

//
// Reset values
//

const AnsiCode resetAll = AnsiCode._(
  'all',
  AnsiCodeType.reset,
  0,
  null,
);

// NOTE: bold is weird. The reset code seems to be 22 sometimes – not 21
// See https://gitlab.com/gnachman/iterm2/issues/3208
const AnsiCode resetBold = AnsiCode._(
  'bold',
  AnsiCodeType.reset,
  22,
  null,
);
const AnsiCode resetDim = AnsiCode._(
  'dim',
  AnsiCodeType.reset,
  22,
  null,
);
const AnsiCode resetItalic = AnsiCode._(
  'italic',
  AnsiCodeType.reset,
  23,
  null,
);
const AnsiCode resetUnderlined = AnsiCode._(
  'underlined',
  AnsiCodeType.reset,
  24,
  null,
);
const AnsiCode resetBlink = AnsiCode._(
  'blink',
  AnsiCodeType.reset,
  25,
  null,
);
const AnsiCode resetReverse = AnsiCode._(
  'reverse',
  AnsiCodeType.reset,
  27,
  null,
);
const AnsiCode resetHidden = AnsiCode._(
  'hidden',
  AnsiCodeType.reset,
  28,
  null,
);
const AnsiCode resetCrossedOut = AnsiCode._(
  'crossed out',
  AnsiCodeType.reset,
  29,
  null,
);

//
// Foreground values
//

const AnsiCode black = AnsiCode._(
  'black',
  AnsiCodeType.foreground,
  30,
  resetAll,
);
const AnsiCode red = AnsiCode._(
  'red',
  AnsiCodeType.foreground,
  31,
  resetAll,
);
const AnsiCode green = AnsiCode._(
  'green',
  AnsiCodeType.foreground,
  32,
  resetAll,
);
const AnsiCode yellow = AnsiCode._(
  'yellow',
  AnsiCodeType.foreground,
  33,
  resetAll,
);
const AnsiCode blue = AnsiCode._(
  'blue',
  AnsiCodeType.foreground,
  34,
  resetAll,
);
const AnsiCode magenta = AnsiCode._(
  'magenta',
  AnsiCodeType.foreground,
  35,
  resetAll,
);
const AnsiCode cyan = AnsiCode._(
  'cyan',
  AnsiCodeType.foreground,
  36,
  resetAll,
);
const AnsiCode lightGray = AnsiCode._(
  'light gray',
  AnsiCodeType.foreground,
  37,
  resetAll,
);
const AnsiCode defaultForeground = AnsiCode._(
  'default',
  AnsiCodeType.foreground,
  39,
  resetAll,
);
const AnsiCode darkGray = AnsiCode._(
  'dark gray',
  AnsiCodeType.foreground,
  90,
  resetAll,
);
const AnsiCode lightRed = AnsiCode._(
  'light red',
  AnsiCodeType.foreground,
  91,
  resetAll,
);
const AnsiCode lightGreen = AnsiCode._(
  'light green',
  AnsiCodeType.foreground,
  92,
  resetAll,
);
const AnsiCode lightYellow = AnsiCode._(
  'light yellow',
  AnsiCodeType.foreground,
  93,
  resetAll,
);
const AnsiCode lightBlue = AnsiCode._(
  'light blue',
  AnsiCodeType.foreground,
  94,
  resetAll,
);
const AnsiCode lightMagenta = AnsiCode._(
  'light magenta',
  AnsiCodeType.foreground,
  95,
  resetAll,
);
const AnsiCode lightCyan = AnsiCode._(
  'light cyan',
  AnsiCodeType.foreground,
  96,
  resetAll,
);
const AnsiCode white = AnsiCode._(
  'white',
  AnsiCodeType.foreground,
  97,
  resetAll,
);

//
// Background values
//

const AnsiCode backgroundBlack = AnsiCode._(
  'black',
  AnsiCodeType.background,
  40,
  resetAll,
);
const AnsiCode backgroundRed = AnsiCode._(
  'red',
  AnsiCodeType.background,
  41,
  resetAll,
);
const AnsiCode backgroundGreen = AnsiCode._(
  'green',
  AnsiCodeType.background,
  42,
  resetAll,
);
const AnsiCode backgroundYellow = AnsiCode._(
  'yellow',
  AnsiCodeType.background,
  43,
  resetAll,
);
const AnsiCode backgroundBlue = AnsiCode._(
  'blue',
  AnsiCodeType.background,
  44,
  resetAll,
);
const AnsiCode backgroundMagenta = AnsiCode._(
  'magenta',
  AnsiCodeType.background,
  45,
  resetAll,
);
const AnsiCode backgroundCyan = AnsiCode._(
  'cyan',
  AnsiCodeType.background,
  46,
  resetAll,
);
const AnsiCode backgroundLightGray = AnsiCode._(
  'light gray',
  AnsiCodeType.background,
  47,
  resetAll,
);
const AnsiCode backgroundDefault = AnsiCode._(
  'default',
  AnsiCodeType.background,
  49,
  resetAll,
);
const AnsiCode backgroundDarkGray = AnsiCode._(
  'dark gray',
  AnsiCodeType.background,
  100,
  resetAll,
);
const AnsiCode backgroundLightRed = AnsiCode._(
  'light red',
  AnsiCodeType.background,
  101,
  resetAll,
);
const AnsiCode backgroundLightGreen = AnsiCode._(
  'light green',
  AnsiCodeType.background,
  102,
  resetAll,
);
const AnsiCode backgroundLightYellow = AnsiCode._(
  'light yellow',
  AnsiCodeType.background,
  103,
  resetAll,
);
const AnsiCode backgroundLightBlue = AnsiCode._(
  'light blue',
  AnsiCodeType.background,
  104,
  resetAll,
);
const AnsiCode backgroundLightMagenta = AnsiCode._(
  'light magenta',
  AnsiCodeType.background,
  105,
  resetAll,
);
const AnsiCode backgroundLightCyan = AnsiCode._(
  'light cyan',
  AnsiCodeType.background,
  106,
  resetAll,
);
const AnsiCode backgroundWhite = AnsiCode._(
  'white',
  AnsiCodeType.background,
  107,
  resetAll,
);

/// All of the [AnsiCode] values that represent [AnsiCodeType.style].
const List<AnsiCode> styles = [
  styleBold,
  styleDim,
  styleItalic,
  styleUnderlined,
  styleBlink,
  styleReverse,
  styleHidden,
  styleCrossedOut
];

/// All of the [AnsiCode] values that represent [AnsiCodeType.foreground].
const List<AnsiCode> foregroundColors = [
  black,
  red,
  green,
  yellow,
  blue,
  magenta,
  cyan,
  lightGray,
  defaultForeground,
  darkGray,
  lightRed,
  lightGreen,
  lightYellow,
  lightBlue,
  lightMagenta,
  lightCyan,
  white
];

/// All of the [AnsiCode] values that represent [AnsiCodeType.background].
const List<AnsiCode> backgroundColors = [
  backgroundBlack,
  backgroundRed,
  backgroundGreen,
  backgroundYellow,
  backgroundBlue,
  backgroundMagenta,
  backgroundCyan,
  backgroundLightGray,
  backgroundDefault,
  backgroundDarkGray,
  backgroundLightRed,
  backgroundLightGreen,
  backgroundLightYellow,
  backgroundLightBlue,
  backgroundLightMagenta,
  backgroundLightCyan,
  backgroundWhite
];

// // Copyright 2017, the Dart project authors.  Please see the AUTHORS file
// // for details. All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.
//
// @TestOn('vm')
// import 'dart:io';
// import 'package:io/ansi.dart';
// import 'package:test/test.dart';
//
// const _ansiEscapeLiteral = '\x1B';
// const _ansiEscapeForScript = '\\033';
// const sampleInput = 'sample input';
//
// void main() {
//   group('ansiOutputEnabled', () {
//     test('default value matches dart:io', () {
//       expect(ansiOutputEnabled,
//           stdout.supportsAnsiEscapes && stderr.supportsAnsiEscapes);
//     });
//
//     test('override true', () {
//       overrideAnsiOutput(true, () {
//         expect(ansiOutputEnabled, isTrue);
//       });
//     });
//
//     test('override false', () {
//       overrideAnsiOutput(false, () {
//         expect(ansiOutputEnabled, isFalse);
//       });
//     });
//
//     test('forScript variaents ignore `ansiOutputEnabled`', () {
//       const expected =
//           '$_ansiEscapeForScript[34m$sampleInput$_ansiEscapeForScript[0m';
//
//       for (var override in [true, false]) {
//         overrideAnsiOutput(override, () {
//           expect(blue.escapeForScript, '$_ansiEscapeForScript[34m');
//           expect(blue.wrap(sampleInput, forScript: true), expected);
//           expect(wrapWith(sampleInput, [blue], forScript: true), expected);
//         });
//       }
//     });
//   });
//
//   test('foreground and background colors match', () {
//     expect(foregroundColors, hasLength(backgroundColors.length));
//
//     for (var i = 0; i < foregroundColors.length; i++) {
//       final foreground = foregroundColors[i];
//       expect(foreground.type, AnsiCodeType.foreground);
//       expect(foreground.name.toLowerCase(), foreground.name,
//           reason: 'All names should be lower case');
//       final background = backgroundColors[i];
//       expect(background.type, AnsiCodeType.background);
//       expect(background.name.toLowerCase(), background.name,
//           reason: 'All names should be lower case');
//
//       expect(foreground.name, background.name);
//
//       // The last base-10 digit also matches – good to sanity check
//       expect(foreground.code % 10, background.code % 10);
//     }
//   });
//
//   test('all styles are styles', () {
//     for (var style in styles) {
//       expect(style.type, AnsiCodeType.style);
//       expect(style.name.toLowerCase(), style.name,
//           reason: 'All names should be lower case');
//       if (style == styleBold) {
//         expect(style.reset, resetBold);
//       } else {
//         expect(style.reset!.code, equals(style.code + 20));
//       }
//       expect(style.name, equals(style.reset!.name));
//     }
//   });
//
//   for (var forScript in [true, false]) {
//     group(forScript ? 'forScript' : 'escaped', () {
//       final escapeLiteral =
//           forScript ? _ansiEscapeForScript : _ansiEscapeLiteral;
//
//       group('wrap', () {
//         _test('color', () {
//           final expected = '$escapeLiteral[34m$sampleInput$escapeLiteral[0m';
//
//           expect(blue.wrap(sampleInput, forScript: forScript), expected);
//         });
//
//         _test('style', () {
//           final expected = '$escapeLiteral[1m$sampleInput$escapeLiteral[22m';
//
//           expect(styleBold.wrap(sampleInput, forScript: forScript), expected);
//         });
//
//         _test('style', () {
//           final expected = '$escapeLiteral[34m$sampleInput$escapeLiteral[0m';
//
//           expect(blue.wrap(sampleInput, forScript: forScript), expected);
//         });
//
//         test('empty', () {
//           expect(blue.wrap('', forScript: forScript), '');
//         });
//
//         test(null, () {
//           expect(blue.wrap(null, forScript: forScript), isNull);
//         });
//       });
//
//       group('wrapWith', () {
//         _test('foreground', () {
//           final expected = '$escapeLiteral[34m$sampleInput$escapeLiteral[0m';
//
//           expect(wrapWith(sampleInput, [blue], forScript: forScript), expected);
//         });
//
//         _test('background', () {
//           final expected = '$escapeLiteral[44m$sampleInput$escapeLiteral[0m';
//
//           expect(wrapWith(sampleInput, [backgroundBlue], forScript: forScript),
//               expected);
//         });
//
//         _test('style', () {
//           final expected = '$escapeLiteral[1m$sampleInput$escapeLiteral[0m';
//
//           expect(wrapWith(sampleInput, [styleBold], forScript: forScript),
//               expected);
//         });
//
//         _test('2 styles', () {
//           final expected = '$escapeLiteral[1;3m$sampleInput$escapeLiteral[0m';
//
//           expect(
//               wrapWith(sampleInput, [styleBold, styleItalic],
//                   forScript: forScript),
//               expected);
//         });
//
//         _test('2 foregrounds', () {
//           expect(
//               () => wrapWith(sampleInput, [blue, white], forScript: forScript),
//               throwsArgumentError);
//         });
//
//         _test('multi', () {
//           final expected =
//               '$escapeLiteral[1;4;34;107m$sampleInput$escapeLiteral[0m';
//
//           expect(
//               wrapWith(sampleInput,
//                   [blue, backgroundWhite, styleBold, styleUnderlined],
//                   forScript: forScript),
//               expected);
//         });
//
//         test('no codes', () {
//           expect(wrapWith(sampleInput, []), sampleInput);
//         });
//
//         _test('empty', () {
//           expect(
//               wrapWith('', [blue, backgroundWhite, styleBold],
//                   forScript: forScript),
//               '');
//         });
//
//         _test('null', () {
//           expect(
//               wrapWith(null, [blue, backgroundWhite, styleBold],
//                   forScript: forScript),
//               isNull);
//         });
//       });
//     });
//   }
// }
//
// void _test<T>(String name, T Function() body) =>
//     test(name, () => overrideAnsiOutput<T>(true, body));

// // Copyright 2017, the Dart project authors.  Please see the AUTHORS file
// // for details. All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.
//
// import 'dart:math';
//
// import 'package:io/ansi.dart';
//
// /// Prints a sample of all of the `AnsiCode` values.
// void main(List<String> args) {
//   final forScript = args.contains('--for-script');
//   if (!ansiOutputEnabled) {
//     print('`ansiOutputEnabled` is `false`.');
//     print("Don't expect pretty output.");
//   }
//   _preview('Foreground', foregroundColors, forScript);
//   _preview('Background', backgroundColors, forScript);
//   _preview('Styles', styles, forScript);
// }
//
// void _preview(String name, List<AnsiCode> values, bool forScript) {
//   print('');
//   final longest = values.map((ac) => ac.name.length).reduce(max);
//   print(wrapWith('** $name **', [styleBold, styleUnderlined]));
//   for (var code in values) {
//     final header = '${code.name.padRight(longest)} ${code.code.toString().padLeft(3)}';
//     print("$header: ${code.wrap('Sample', forScript: forScript)}");
//   }
// }
