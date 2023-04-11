import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

void main() {
  final output_handle = GetStdHandle(STD_OUTPUT_HANDLE);
  print('Output handle (DWORD): $output_handle');
  final p_buffer_info = calloc<CONSOLE_SCREEN_BUFFER_INFO>();
  final buffer_info = p_buffer_info.ref;
  GetConsoleScreenBufferInfo(
    output_handle,
    p_buffer_info,
  );
  print(
    'Window dimensions LTRB: (${buffer_info.srWindow.Left}, ${buffer_info.srWindow.Top}, ${buffer_info.srWindow.Right}, ${buffer_info.srWindow.Bottom})',
  );
  print(
    'Cursor position X/Y: (${buffer_info.dwCursorPosition.X}, ${buffer_info.dwCursorPosition.Y})',
  );
  print(
    'Window size X/Y: (${buffer_info.dwSize.X}, ${buffer_info.dwSize.Y})',
  );
  print(
    'Maximum window size X/Y: (${buffer_info.dwMaximumWindowSize.X}, ${buffer_info.dwMaximumWindowSize.Y})',
  );
  final cursor_position = calloc<COORD>()
    ..ref.X = 15
    ..ref.Y = 3;
  SetConsoleCursorPosition(output_handle, cursor_position.ref);
  GetConsoleScreenBufferInfo(output_handle, p_buffer_info);
  print(
    'Cursor position X/Y: (${buffer_info.dwCursorPosition.X}, ${buffer_info.dwCursorPosition.Y})',
  );
  calloc.free(p_buffer_info);
  calloc.free(cursor_position);
}
