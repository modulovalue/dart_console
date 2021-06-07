import '../../../console/interface/key.dart';

abstract class AnsiParserInputBuffer {
  int readByte();
}

abstract class AnsiParser {
  Key readKey();
}

abstract class ByteReadExceptionTooSmall implements Exception {
  int get value;

  String get message;
}
