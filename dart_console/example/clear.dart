import 'dart:io';

void main() {
  stdout.write(ansiEraseInDisplayAll + ansiResetCursorPosition);
}

const ansiEraseInDisplayAll = '\x1b[2J';

const ansiResetCursorPosition = '\x1b[H';
