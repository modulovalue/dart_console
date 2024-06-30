import 'dart:io';
import 'dart:math' show min;

import 'package:dart_console3/console/impl.dart';
import 'package:dart_console3/console/interface.dart';
import 'package:dart_console3/terminal/terminal_lib_auto.dart';

void main(
  final List<String> arguments,
) {
  try {
    console.set_raw_mode(true);
    init_editor();
    if (arguments.isNotEmpty) {
      edited_filename = arguments[0];
      editor_open(edited_filename);
    }
    editor_set_status_message(
        'HELP: Ctrl-S = save | Ctrl-Q = quit | Ctrl-F = find');
    for (;;) {
      editor_refresh_screen();
      editor_process_keypress();
    }
    // ignore: avoid_catches_without_on_clauses
  } catch (exception) {
    // Make sure raw mode gets disabled if we hit some unrelated problem
    console.set_raw_mode(false);
    rethrow;
  }
}

const kilo_version = '0.0.3';
const kilo_tab_stop_length = 4;

final console = SneathConsoleImpl(
  terminal: auto_sneath_terminal(),
);

String edited_filename = '';
bool is_file_dirty = false;

// We keep two copies of the file contents, as follows:
//
// fileRows represents the actual contents of the document
//
// renderRows represents what we'll render on screen. This may be different to
// the actual contents of the file. For example, tabs are rendered as a series
// of spaces even though they are only one character; control characters may
// be shown in some form in the future.
List<String> file_rows = [];
List<String> render_rows = [];

// Cursor location relative to file (not the screen)
int cursor_col = 0;
int cursor_row = 0;

// Also store cursor column position relative to the rendered row
int cursor_render_col = 0;

// The row in the file that is currently at the top of the screen
int screen_file_row_offset = 0;
// The column in the row that is currently on the left of the screen
int screenRowColOffset = 0;

// Allow lines for the status bar and message bar
final editor_window_height = console.dimensions.height - 2;
final editor_window_width = console.dimensions.width;

// Index of the row last find match was on, or -1 if no match
int find_last_match_row = -1;

// Current search direction
enum FindDirection {
  forwards,
  backwards,
}

FindDirection find_direction = FindDirection.forwards;

String message_text = '';
late DateTime message_timestamp;

void init_editor() {
  is_file_dirty = false;
}

void crash(
  final String message,
) {
  console.clear_screen();
  console.reset_cursor_position();
  console.set_raw_mode(false);
  console.write(message);
  exit(1);
}

String truncate_string(
  final String text,
  final int length,
) {
  if (length < text.length) {
    return text.substring(0, length);
  } else {
    return text;
  }
}

//
// EDITOR OPERATIONS
//
void editor_insert_char(
  final String char,
) {
  if (cursor_row == file_rows.length) {
    file_rows.add(char);
    render_rows.add(char);
  } else {
    file_rows[cursor_row] = file_rows[cursor_row].substring(0, cursor_col) +
        char +
        file_rows[cursor_row].substring(cursor_col);
  }
  editor_update_render_row(cursor_row);
  cursor_col++;
  is_file_dirty = true;
}

void editor_backspace_char() {
  // If we're past the end of the file, then there's nothing to delete
  if (cursor_row == file_rows.length) {
    return;
  }
  // Nothing to do if we're at the first character of the file
  if (cursor_col == 0 && cursor_row == 0) {
    return;
  }
  if (cursor_col > 0) {
    file_rows[cursor_row] = file_rows[cursor_row].substring(0, cursor_col - 1) +
        file_rows[cursor_row].substring(cursor_col);
    editor_update_render_row(cursor_row);
    cursor_col--;
  } else {
    // delete the carriage return by appending the current line to the previous
    // one and then removing the current line altogether.
    cursor_col = file_rows[cursor_row - 1].length;
    file_rows[cursor_row - 1] += file_rows[cursor_row];
    editor_update_render_row(cursor_row - 1);
    file_rows.removeAt(cursor_row);
    render_rows.removeAt(cursor_row);
    cursor_row--;
  }
  is_file_dirty = true;
}

void editor_insert_newline() {
  if (cursor_col == 0) {
    file_rows.insert(cursor_row, '');
    render_rows.insert(cursor_row, '');
  } else {
    file_rows.insert(
        cursor_row + 1, file_rows[cursor_row].substring(cursor_col));
    file_rows[cursor_row] = file_rows[cursor_row].substring(0, cursor_col);
    render_rows.insert(cursor_row + 1, '');
    editor_update_render_row(cursor_row);
    editor_update_render_row(cursor_row + 1);
  }
  cursor_row++;
  cursor_col = 0;
}

void _handle_other([
  final Object? _,
]) {
  find_last_match_row = -1;
  find_direction = FindDirection.forwards;
}

void editor_find_callback(
  final String query,
  final Key key,
) {
  key.match(
    printable: _handle_other,
    control: (final key) {
      if (key.control_char == ControlCharacters.enter ||
          key.control_char == ControlCharacters.escape) {
        find_last_match_row = -1;
        find_direction = FindDirection.forwards;
        return;
      } else if (key.control_char == ControlCharacters.arrowRight ||
          key.control_char == ControlCharacters.arrowDown) {
        find_direction = FindDirection.forwards;
      } else if (key.control_char == ControlCharacters.arrowLeft ||
          key.control_char == ControlCharacters.arrowUp) {
        find_direction = FindDirection.backwards;
      } else {
        _handle_other();
      }
    },
  );
  if (find_last_match_row == -1) {
    find_direction = FindDirection.forwards;
  }
  int current_row = find_last_match_row;
  if (query.isNotEmpty) {
    // we loop through all the rows, rotating back to the beginning/end as
    // necessary
    for (int i = 0; i < render_rows.length; i++) {
      if (find_direction == FindDirection.forwards) {
        current_row++;
      } else {
        current_row--;
      }
      if (current_row == -1) {
        current_row = file_rows.length - 1;
      } else if (current_row == file_rows.length) {
        current_row = 0;
      }
      if (render_rows[current_row].contains(query)) {
        find_last_match_row = current_row;
        cursor_row = current_row;
        cursor_col =
            get_file_col(current_row, render_rows[current_row].indexOf(query));
        screen_file_row_offset = file_rows.length;
        editor_set_status_message(
            'Search (ESC to cancel, use arrows for prev/next): $query');
        editor_refresh_screen();
        break;
      }
    }
  }
}

void editor_find() {
  final saved_cursor_col = cursor_col;
  final saved_cursor_row = cursor_row;
  final saved_screen_file_row_offset = screen_file_row_offset;
  final saved_screen_row_col_offset = screenRowColOffset;
  final query = editor_prompt(
      'Search (ESC to cancel, use arrows for prev/next): ',
      editor_find_callback);
  if (query == null) {
    // Escape pressed
    cursor_col = saved_cursor_col;
    cursor_row = saved_cursor_row;
    screen_file_row_offset = saved_screen_file_row_offset;
    screenRowColOffset = saved_screen_row_col_offset;
  }
}

// FILE I/O
void editor_open(
  final String filename,
) {
  final file = File(filename);
  try {
    file_rows = file.readAsLinesSync();
  } on FileSystemException catch (e) {
    editor_set_status_message('Error opening file: $e');
    return;
  }
  for (int rowIndex = 0; rowIndex < file_rows.length; rowIndex++) {
    render_rows.add('');
    editor_update_render_row(rowIndex);
  }
  assert(file_rows.length == render_rows.length, "");
  is_file_dirty = false;
}

void editor_save() {
  if (edited_filename.isEmpty) {
    final save_filename = editor_prompt('Save as: ');
    if (save_filename == null) {
      editor_set_status_message('Save aborted.');
      return;
    } else {
      edited_filename = save_filename;
    }
  }
  // This is hopelessly naive, as with kilo.c.
  // We should write to a temporary file and
  // rename to ensure that we have written successfully.
  final file = File(edited_filename);
  final file_contents = file_rows.join('\n') + '\n';
  file.writeAsStringSync(file_contents);
  is_file_dirty = false;
  editor_set_status_message('${file_contents.length} bytes written to disk.');
}

void editor_quit() {
  if (is_file_dirty) {
    editor_set_status_message('File is unsaved. Quit anyway (y or n)?');
    editor_refresh_screen();
    final response = console.read_key();
    if (response.match(
      printable: (final key) {
        if (key.char != 'y' && key.char != 'Y') {
          editor_set_status_message('');
          return true;
        } else {
          return false;
        }
      },
      control: (final key) => false,
    )) {
      return;
    }
  }
  console.clear_screen();
  console.reset_cursor_position();
  console.set_raw_mode(false);
  exit(0);
}

//
// RENDERING OPERATIONS
//

// Takes a column in a given row of the file and converts it to the rendered
// column. For example, if the file contains \t\tFoo and tab stops are
// configured to display as eight spaces, the 'F' should display as rendered
// column 16 even though it is only the third character in the file.
int get_rendered_col(
  final int file_row,
  final int file_col,
) {
  int col = 0;
  if (file_row >= file_rows.length) {
    return 0;
  } else {
    final row_text = file_rows[file_row];
    for (int i = 0; i < file_col; i++) {
      if (row_text[i] == '\t') {
        col += (kilo_tab_stop_length - 1) - (col % kilo_tab_stop_length);
      }
      col++;
    }
    return col;
  }
}

// Inversion of the getRenderedCol method. Converts a rendered column index
// into its corresponding position in the file.
int get_file_col(
  final int row,
  final int renderCol,
) {
  int current_render_col = 0;
  int file_col;
  final row_text = file_rows[row];
  for (file_col = 0; file_col < row_text.length; file_col++) {
    if (row_text[file_col] == '\t') {
      current_render_col += (kilo_tab_stop_length - 1) -
          (current_render_col % kilo_tab_stop_length);
    }
    current_render_col++;
    if (current_render_col > renderCol) {
      return file_col;
    }
  }
  return file_col;
}

void editor_update_render_row(
  final int rowIndex,
) {
  assert(render_rows.length == file_rows.length, "");
  String render_buffer = '';
  final fileRow = file_rows[rowIndex];
  for (int fileCol = 0; fileCol < fileRow.length; fileCol++) {
    if (fileRow[fileCol] == '\t') {
      // Add at least one space for the tab stop, plus as many more as needed to
      // get to the next tab stop
      render_buffer += ' ';
      while (render_buffer.length % kilo_tab_stop_length != 0) {
        // ignore: use_string_buffers
        render_buffer += ' ';
      }
    } else {
      render_buffer += fileRow[fileCol];
    }
    render_rows[rowIndex] = render_buffer;
  }
}

void editor_scroll() {
  cursor_render_col = 0;
  if (cursor_row < file_rows.length) {
    cursor_render_col = get_rendered_col(cursor_row, cursor_col);
  }
  if (cursor_row < screen_file_row_offset) {
    screen_file_row_offset = cursor_row;
  }
  if (cursor_row >= screen_file_row_offset + editor_window_height) {
    screen_file_row_offset = cursor_row - editor_window_height + 1;
  }
  if (cursor_render_col < screenRowColOffset) {
    screenRowColOffset = cursor_render_col;
  }
  if (cursor_render_col >= screenRowColOffset + editor_window_width) {
    screenRowColOffset = cursor_render_col - editor_window_width + 1;
  }
}

void editor_draw_rows() {
  final screen_buffer = StringBuffer();
  for (int screen_row = 0; screen_row < editor_window_height; screen_row++) {
    // fileRow is the row of the file we want to print to screenRow
    final file_row = screen_row + screen_file_row_offset;
    // If we're beyond the text buffer, print tilde in column 0
    if (file_row >= file_rows.length) {
      // Show a welcome message
      if (file_rows.isEmpty &&
          (screen_row == (editor_window_height / 3).round())) {
        // Print the welcome message centered a third of the way down the screen
        final welcome_message = truncate_string(
          'Kilo editor -- version $kilo_version',
          editor_window_width,
        );
        int padding =
            ((editor_window_width - welcome_message.length) / 2).round();
        if (padding > 0) {
          screen_buffer.write('~');
          padding--;
        }
        while (padding-- > 0) {
          screen_buffer.write(' ');
        }
        screen_buffer.write(welcome_message);
      } else {
        screen_buffer.write('~');
      }
    }
    // Otherwise print the onscreen portion of the current file row,
    // trimmed if necessary
    else {
      if (render_rows[file_row].length - screenRowColOffset > 0) {
        screen_buffer.write(
          truncate_string(
            render_rows[file_row].substring(screenRowColOffset),
            editor_window_width,
          ),
        );
      }
    }
    screen_buffer.write(console.new_line);
  }
  console.write(screen_buffer.toString());
}

void editor_draw_status_bar() {
  console.set_text_style(inverted: true);
  // TODO: Displayed filename should not include path.
  String left_string = truncate_string(() {
        if (edited_filename.isEmpty) {
          return "[No Name]";
        } else {
          return edited_filename;
        }
      }(), (editor_window_width / 2).ceil()) +
      ' - ${file_rows.length} lines';
  if (is_file_dirty) {
    left_string += ' (modified)';
  }
  final right_string = '${cursor_row + 1}/${file_rows.length}';
  final padding =
      editor_window_width - left_string.length - right_string.length;
  console.write('$left_string${" " * padding}$right_string');
  console.reset_color_attributes();
  console.write_line();
}

void editor_draw_message_bar() {
  if (DateTime.now().difference(message_timestamp) <
      const Duration(seconds: 5)) {
    console.write(truncate_string(message_text, editor_window_width)
        .padRight(editor_window_width));
  }
}

void editor_refresh_screen() {
  editor_scroll();
  console.hide_cursor();
  console.clear_screen();
  editor_draw_rows();
  editor_draw_status_bar();
  editor_draw_message_bar();
  console.cursor_position.update(
    SneathCoordinateImpl(
      row: cursor_row - screen_file_row_offset,
      col: cursor_render_col - screenRowColOffset,
    ),
  );
  console.show_cursor();
}

void editor_set_status_message(
  final String message,
) {
  message_text = message;
  message_timestamp = DateTime.now();
}

String? editor_prompt(
  final String message, [
  final void Function(String text, Key lastPressed)? callback,
]) {
  final original_cursor_row = cursor_row;
  editor_set_status_message(message);
  editor_refresh_screen();
  console.cursor_position.update(
    SneathCoordinateImpl(
      row: console.dimensions.height - 1,
      col: message.length,
    ),
  );
  final response = console.read_line(
    cancel_on_escape: true,
    callback: callback,
  );
  cursor_row = original_cursor_row;
  editor_set_status_message('');
  return response;
}

// INPUT OPERATIONS
void editor_move_cursor(
  final ControlCharacter key,
) {
  switch (key) {
    case ControlCharacters.arrowLeft:
      if (cursor_col != 0) {
        cursor_col--;
      } else if (cursor_row > 0) {
        cursor_row--;
        cursor_col = file_rows[cursor_row].length;
      }
      break;
    case ControlCharacters.arrowRight:
      if (cursor_row < file_rows.length) {
        if (cursor_col < file_rows[cursor_row].length) {
          cursor_col++;
        } else if (cursor_col == file_rows[cursor_row].length) {
          cursor_col = 0;
          cursor_row++;
        }
      }
      break;
    case ControlCharacters.arrowUp:
      if (cursor_row != 0) {
        cursor_row--;
      }
      break;
    case ControlCharacters.arrowDown:
      if (cursor_row < file_rows.length) {
        cursor_row++;
      }
      break;
    case ControlCharacters.pageUp:
      cursor_row = screen_file_row_offset;
      for (int i = 0; i < editor_window_height; i++) {
        editor_move_cursor(ControlCharacters.arrowUp);
      }
      break;
    case ControlCharacters.pageDown:
      cursor_row = screen_file_row_offset + editor_window_height - 1;
      for (int i = 0; i < editor_window_height; i++) {
        editor_move_cursor(ControlCharacters.arrowDown);
      }
      break;
    case ControlCharacters.home:
      cursor_col = 0;
      break;
    case ControlCharacters.end:
      if (cursor_row < file_rows.length) {
        cursor_col = file_rows[cursor_row].length;
      }
      break;
    case ControlCharacters.ctrlA:
    case ControlCharacters.ctrlB:
    case ControlCharacters.ctrlC:
    case ControlCharacters.ctrlD:
    case ControlCharacters.ctrlE:
    case ControlCharacters.ctrlF:
    case ControlCharacters.ctrlG:
    case ControlCharacters.ctrlH:
    case ControlCharacters.tab:
    case ControlCharacters.ctrlJ:
    case ControlCharacters.ctrlK:
    case ControlCharacters.ctrlL:
    case ControlCharacters.enter:
    case ControlCharacters.ctrlN:
    case ControlCharacters.ctrlO:
    case ControlCharacters.ctrlP:
    case ControlCharacters.ctrlQ:
    case ControlCharacters.ctrlR:
    case ControlCharacters.ctrlS:
    case ControlCharacters.ctrlT:
    case ControlCharacters.ctrlU:
    case ControlCharacters.ctrlV:
    case ControlCharacters.ctrlW:
    case ControlCharacters.ctrlX:
    case ControlCharacters.ctrlY:
    case ControlCharacters.ctrlZ:
    case ControlCharacters.wordLeft:
    case ControlCharacters.wordRight:
    case ControlCharacters.escape:
    case ControlCharacters.delete:
    case ControlCharacters.backspace:
    case ControlCharacters.wordBackspace:
    case ControlCharacters.F1:
    case ControlCharacters.F2:
    case ControlCharacters.F3:
    case ControlCharacters.F4:
    case ControlCharacters.unknown:
      // Do nothing.
      break;
  }
  if (cursor_row < file_rows.length) {
    cursor_col = min(cursor_col, file_rows[cursor_row].length);
  }
}

void editor_process_keypress() {
  console.read_key().match(
        printable: (final key) => editor_insert_char(key.char),
        control: (final key) {
          switch (key.control_char) {
            case ControlCharacters.ctrlQ:
              editor_quit();
              break;
            case ControlCharacters.ctrlS:
              editor_save();
              break;
            case ControlCharacters.ctrlF:
              editor_find();
              break;
            case ControlCharacters.backspace:
            case ControlCharacters.ctrlH:
              editor_backspace_char();
              break;
            case ControlCharacters.delete:
              editor_move_cursor(ControlCharacters.arrowRight);
              editor_backspace_char();
              break;
            case ControlCharacters.enter:
              editor_insert_newline();
              break;
            case ControlCharacters.arrowLeft:
            case ControlCharacters.arrowUp:
            case ControlCharacters.arrowRight:
            case ControlCharacters.arrowDown:
            case ControlCharacters.pageUp:
            case ControlCharacters.pageDown:
            case ControlCharacters.home:
            case ControlCharacters.end:
              editor_move_cursor(key.control_char);
              break;
            case ControlCharacters.ctrlA:
              editor_move_cursor(ControlCharacters.home);
              break;
            case ControlCharacters.ctrlE:
              editor_move_cursor(ControlCharacters.end);
              break;
            case ControlCharacters.ctrlB:
            case ControlCharacters.ctrlC:
            case ControlCharacters.ctrlD:
            case ControlCharacters.ctrlG:
            case ControlCharacters.tab:
            case ControlCharacters.ctrlJ:
            case ControlCharacters.ctrlK:
            case ControlCharacters.ctrlL:
            case ControlCharacters.ctrlN:
            case ControlCharacters.ctrlO:
            case ControlCharacters.ctrlP:
            case ControlCharacters.ctrlR:
            case ControlCharacters.ctrlT:
            case ControlCharacters.ctrlU:
            case ControlCharacters.ctrlV:
            case ControlCharacters.ctrlW:
            case ControlCharacters.ctrlX:
            case ControlCharacters.ctrlY:
            case ControlCharacters.ctrlZ:
            case ControlCharacters.wordLeft:
            case ControlCharacters.wordRight:
            case ControlCharacters.escape:
            case ControlCharacters.wordBackspace:
            case ControlCharacters.F1:
            case ControlCharacters.F2:
            case ControlCharacters.F3:
            case ControlCharacters.F4:
            case ControlCharacters.unknown:
              // Do nothing.
              break;
          }
        },
      );
}
