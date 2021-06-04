import '../../ansi/impl/ansi.dart';
import '../interface/control_character.dart';
import '../interface/key.dart';
import 'key.dart';

abstract class AnsiParserInputBuffer {
  int readByte();
}

abstract class AnsiParser {
  Key readKey();
}

class AnsiParserImpl implements AnsiParser {
  final AnsiParserInputBuffer buffer;

  const AnsiParserImpl(this.buffer);

  @override
  Key readKey() {
    final codeUnit = readContinuousByte();
    /// TODO be explicit about what each byte represents.
    switch (codeUnit) {
      // https://en.wikipedia.org/wiki/ASCII#Control_characters
      case 0:
        return const KeyControlImpl(ControlCharacters.unknown);
      case 1:
        return const KeyControlImpl(ControlCharacters.ctrlA);
      case 2:
        return const KeyControlImpl(ControlCharacters.ctrlB);
      case 3:
        return const KeyControlImpl(ControlCharacters.ctrlC);
      case 4:
        return const KeyControlImpl(ControlCharacters.ctrlD);
      case 5:
        return const KeyControlImpl(ControlCharacters.ctrlE);
      case 6:
        return const KeyControlImpl(ControlCharacters.ctrlF);
      case 7:
        return const KeyControlImpl(ControlCharacters.ctrlG);
      case 8:
        return const KeyControlImpl(ControlCharacters.ctrlH);
      case 9:
        return const KeyControlImpl(ControlCharacters.tab);
      case 10:
        return const KeyControlImpl(ControlCharacters.ctrlJ);
      case 11:
        return const KeyControlImpl(ControlCharacters.ctrlK);
      case 12:
        return const KeyControlImpl(ControlCharacters.ctrlL);
      case ControlCharacterEnterImpl.byteIndicator:
        return const KeyControlImpl(ControlCharacters.enter);
      case 14:
        return const KeyControlImpl(ControlCharacters.ctrlN);
      case 15:
        return const KeyControlImpl(ControlCharacters.ctrlO);
      case 16:
        return const KeyControlImpl(ControlCharacters.ctrlP);
      case 17:
        return const KeyControlImpl(ControlCharacters.ctrlQ);
      case 18:
        return const KeyControlImpl(ControlCharacters.ctrlR);
      case 19:
        return const KeyControlImpl(ControlCharacters.ctrlS);
      case 20:
        return const KeyControlImpl(ControlCharacters.ctrlT);
      case 21:
        return const KeyControlImpl(ControlCharacters.ctrlU);
      case 22:
        return const KeyControlImpl(ControlCharacters.ctrlV);
      case 23:
        return const KeyControlImpl(ControlCharacters.ctrlW);
      case 24:
        return const KeyControlImpl(ControlCharacters.ctrlX);
      case 25:
        return const KeyControlImpl(ControlCharacters.ctrlY);
      case 26:
        return const KeyControlImpl(ControlCharacters.ctrlZ);
      case AnsiConstants.escapeByte:
        final firstCharCode = buffer.readByte();
        final firstChar = String.fromCharCode(firstCharCode);
        if (firstCharCode == AnsiConstants.stdinEndOfFileIndicator) {
          return const KeyControlImpl(ControlCharacters.escape);
        } else if (firstCharCode == 127) {
          return const KeyControlImpl(ControlCharacters.wordBackspace);
        } else if (firstCharCode == AnsiConstants.ansiBracketByte) {
          return parseBracket();
        } else if (firstChar == AnsiConstants.commandOPrefix) {
          return parseO();
        } else if (firstChar == AnsiConstants.charWordLeft) {
          return const KeyControlImpl(ControlCharacters.wordLeft);
        } else if (firstChar == AnsiConstants.charWordRight) {
          return const KeyControlImpl(ControlCharacters.wordRight);
        } else {
          return const KeyControlImpl(ControlCharacters.unknown);
        }
      case 28:
        return const KeyControlImpl(ControlCharacters.unknown);
      case 29:
        return const KeyControlImpl(ControlCharacters.unknown);
      case 30:
        return const KeyControlImpl(ControlCharacters.unknown);
      case 31:
        return const KeyControlImpl(ControlCharacters.unknown);

      /// https://en.wikipedia.org/wiki/ASCII#Printable_characters
      case 32: // ' '
      case 33: // !
      case 34: // "
      case 35: // #
      case 36: // $
      case 37: // %
      case 38: // &
      case 39: // '
      case 40: // (
      case 41: // )
      case 42: // *
      case 43: // +
      case 44: // ,
      case 45: // -
      case 46: // .
      case 47: // /
      case 48: // 0
      case 49: // 1
      case 50: // 2
      case 51: // 3
      case 52: // 4
      case 53: // 5
      case 54: // 6
      case 55: // 7
      case 56: // 8
      case 57: // 9
      case 58: // :
      case 59: // ;
      case 60: // <
      case 61: // =
      case 62: // >
      case 63: // ?
      case 64: // @
      case 65: // A
      case 66: // B
      case 67: // C
      case 68: // D
      case 69: // E
      case 70: // F
      case 71: // G
      case 72: // H
      case 73: // I
      case 74: // J
      case 75: // K
      case 76: // L
      case 77: // M
      case 78: // N
      case 79: // O
      case 80: // P
      case 81: // Q
      case 82: // R
      case 83: // S
      case 84: // T
      case 85: // U
      case 86: // V
      case 87: // W
      case 88: // X
      case 89: // Y
      case 90: // Z
      case 91: // [
      case 92: // \
      case 93: // ]
      case 94: // ^
      case 95: // _
      case 96: // `
      case 97: // a
      case 98: // b
      case 99: // c
      case 100: // d
      case 101: // e
      case 102: // f
      case 103: // g
      case 104: // h
      case 105: // i
      case 106: // j
      case 107: // k
      case 108: // l
      case 109: // m
      case 110: // n
      case 111: // o
      case 112: // p
      case 113: // q
      case 114: // r
      case 115: // s
      case 116: // t
      case 117: // u
      case 118: // v
      case 119: // w
      case 120: // x
      case 121: // y
      case 122: // z
      case 123: // {
      case 124: // |
      case 125: // }
      case 126: // ~
        return KeyPrintableImpl(String.fromCharCode(codeUnit));
      case 127:
        return const KeyControlImpl(ControlCharacters.backspace);
      // https://www.torsten-horn.de/techdocs/ascii.htm
      case 128:
      case 129:
      case 130:
      case 131:
      case 132:
      case 133:
      case 134:
      case 135:
      case 136:
      case 137:
      case 138:
      case 139:
      case 140:
      case 141:
      case 142:
      case 143:
      case 144:
      case 145:
      case 146:
      case 147:
      case 148:
      case 149:
      case 150:
      case 151:
      case 152:
      case 153:
      case 154:
      case 155:
      case 156:
      case 157:
      case 158:
      case 159:
      case 160:
      case 161:
      case 162:
      case 163:
      case 164:
      case 165:
      case 166:
      case 167:
      case 168:
      case 169:
      case 170:
      case 171:
      case 172:
      case 173:
      case 174:
      case 175:
      case 176:
      case 177:
      case 178:
      case 179:
      case 180:
      case 181:
      case 182:
      case 183:
      case 184:
      case 185:
      case 186:
      case 187:
      case 188:
      case 189:
      case 190:
      case 191:
      case 192:
      case 193:
      case 194:
      case 195:
      case 196:
      case 197:
      case 198:
      case 199:
      case 200:
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
      case 206:
      case 207:
      case 208:
      case 209:
      case 211:
      case 212:
      case 213:
      case 214:
      case 215:
      case 216:
      case 217:
      case 218:
      case 219:
      case 221:
      case 222:
      case 223:
      case 224:
      case 225:
      case 226:
      case 227:
      case 228:
      case 229:
      case 231:
      case 232:
      case 233:
      case 234:
      case 235:
      case 236:
      case 237:
      case 238:
      case 239:
      case 241:
      case 242:
      case 243:
      case 244:
      case 245:
      case 246:
      case 247:
      case 248:
      case 249:
      case 251:
      case 252:
      case 253:
      case 254:
      case 255:
        return KeyPrintableImpl(String.fromCharCode(codeUnit));
    }
    if (codeUnit >= AnsiConstants.byteStart && codeUnit <= AnsiConstants.byteSize) {
      throw Exception("Forgot to handle case for the byte $codeUnit whic is '${String.fromCharCode(codeUnit)}'");
    } else {
      throw Exception("Read an unexpected key ${codeUnit} whic is '${String.fromCharCode(codeUnit)}'. A byte was expected.");
    }
  }

  int readContinuousByte() {
    var _readByte = 0;
    while (_readByte <= 0) {
      _readByte = buffer.readByte();
      // Stdin constantly emits a -1.
      if (_readByte < AnsiConstants.stdinEndOfFileIndicator) {
        throw ByteReadExceptionTooSmallImpl(_readByte);
      } else if (_readByte > AnsiConstants.byteSize) {
        throw ByteReadExceptionTooLargeImpl(_readByte);
      }
    }
    return _readByte;
  }

  Key parseO() {
    final secondCharCode = buffer.readByte();
    final secondChar = String.fromCharCode(secondCharCode);
    if (secondCharCode == AnsiConstants.stdinEndOfFileIndicator) {
      return const KeyControlImpl(ControlCharacters.escape);
    } else {
      switch (secondChar) {
        case ControlCharacterHomeImpl.bigOStringIndicator:
          return const KeyControlImpl(ControlCharacters.home);
        case ControlCharacterEndImpl.bigOStringIndicator:
          return const KeyControlImpl(ControlCharacters.end);
        case ControlCharacterF1Impl.bigOStringIndicator:
          return const KeyControlImpl(ControlCharacters.F1);
        case ControlCharacterF2Impl.bigOStringIndicator:
          return const KeyControlImpl(ControlCharacters.F2);
        case ControlCharacterF3Impl.bigOStringIndicator:
          return const KeyControlImpl(ControlCharacters.F3);
        case ControlCharacterF4Impl.bigOStringIndicator:
          return const KeyControlImpl(ControlCharacters.F4);
        default:
          throw Exception("Unexpected O command");
      }
    }
  }

  Key parseBracket() {
    final secondCharCode = buffer.readByte();
    final secondChar = String.fromCharCode(secondCharCode);
    if (secondCharCode == AnsiConstants.stdinEndOfFileIndicator) {
      return const KeyControlImpl(ControlCharacters.escape);
    } else {
      switch (secondChar) {
        case ControlCharacterArrowUpImpl.stringIndicator:
          return const KeyControlImpl(ControlCharacters.arrowUp);
        case ControlCharacterArrowDownImpl.stringIndicator:
          return const KeyControlImpl(ControlCharacters.arrowDown);
        case ControlCharacterArrowRightImpl.stringIndicator:
          return const KeyControlImpl(ControlCharacters.arrowRight);
        case ControlCharacterArrowLeftImpl.stringIndicator:
          return const KeyControlImpl(ControlCharacters.arrowLeft);
        case ControlCharacterHomeImpl.bigOStringIndicator:
          return const KeyControlImpl(ControlCharacters.home);
        case ControlCharacterEndImpl.stringIndicator:
          return const KeyControlImpl(ControlCharacters.end);
        default:
          if (secondChar.codeUnits[0] > '0'.codeUnits[0] && secondChar.codeUnits[0] < '9'.codeUnits[0]) {
            final thirdCharCode = buffer.readByte();
            final thirdChar = String.fromCharCode(thirdCharCode);
            if (thirdCharCode == AnsiConstants.stdinEndOfFileIndicator) {
              return const KeyControlImpl(ControlCharacters.escape);
            } else {
              if (thirdChar != '~') {
                return const KeyControlImpl(ControlCharacters.unknown);
              } else {
                switch (secondChar) {
                  case '1':
                    return const KeyControlImpl(ControlCharacters.home);
                  case '3':
                    return const KeyControlImpl(ControlCharacters.delete);
                  case '4':
                    return const KeyControlImpl(ControlCharacters.end);
                  case '5':
                    return const KeyControlImpl(ControlCharacters.pageUp);
                  case '6':
                    return const KeyControlImpl(ControlCharacters.pageDown);
                  case '7':
                    return const KeyControlImpl(ControlCharacters.home);
                  case '8':
                    return const KeyControlImpl(ControlCharacters.end);
                  default:
                    return const KeyControlImpl(ControlCharacters.unknown);
                }
              }
            }
          } else {
            return const KeyControlImpl(ControlCharacters.unknown);
          }
      }
    }
  }
}

abstract class ByteReadException implements Exception {
  int get value;

  String get message;
}

abstract class ByteReadExceptionTooSmall implements ByteReadException {}

abstract class ByteReadExceptionTooLarge implements ByteReadException {}

class ByteReadExceptionTooSmallImpl implements ByteReadExceptionTooSmall {
  @override
  final int value;

  const ByteReadExceptionTooSmallImpl(this.value);

  @override
  String get message => "Read invalid byte. Number was below ${AnsiConstants.stdinEndOfFileIndicator} $value";

  @override
  String toString() => message;
}

class ByteReadExceptionTooLargeImpl implements ByteReadExceptionTooLarge {
  @override
  final int value;

  const ByteReadExceptionTooLargeImpl(this.value);

  @override
  String get message => "Read invalid byte. Number larger than a byte $value";

  @override
  String toString() => message;
}
