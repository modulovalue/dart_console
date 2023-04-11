import 'dart:io';

void main() {
  stdout.write(
    ansi_erase_in_display_all + ansi_reset_cursor_position,
  );
}

const ansi_erase_in_display_all = '\x1b[2J';

const ansi_reset_cursor_position = '\x1b[H';
